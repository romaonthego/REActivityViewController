//
// AFXAuthClient.m
// AFXAuthClient
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Based on AFOAuth1Client, copyright (c) 2011 Mattt Thompson (http://mattt.me/)
// and TwitterXAuth, copyright (c) 2010 Eric Johnson (https://github.com/ericjohnson)
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "AFXAuthClient.h"
#import "AFHTTPRequestOperation.h"

#import <CommonCrypto/CommonHMAC.h>

static NSString * AFEncodeBase64WithData(NSData *data)
{
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

static NSString * AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSDictionary * AFParametersFromQueryString(NSString *queryString)
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (queryString) {
        NSScanner *parameterScanner = [[NSScanner alloc] initWithString:queryString];
        NSString *name = nil;
        NSString *value = nil;
        
        while (![parameterScanner isAtEnd]) {
            name = nil;
            [parameterScanner scanUpToString:@"=" intoString:&name];
            [parameterScanner scanString:@"=" intoString:NULL];
            
            value = nil;
            [parameterScanner scanUpToString:@"&" intoString:&value];
            [parameterScanner scanString:@"&" intoString:NULL];
            
            if (name && value) {
                [parameters setValue:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    
    return parameters;
}

static inline NSString * AFNounce()
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return (NSString *)CFBridgingRelease(string);
}


static inline NSString * AFHMACSHA1Signature(NSString *baseString, NSString *consumerSecret, NSString *tokenSecret)
{
    NSString *secret = tokenSecret ? tokenSecret : @"";
    NSString *secretString = [NSString stringWithFormat:@"%@&%@", consumerSecret, secret];
    NSData *secretData = [secretString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baseData = [baseString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[20] = {0};
    CCHmac(kCCHmacAlgSHA1, secretData.bytes, secretData.length, baseData.bytes, baseData.length, digest);
    NSData *signatureData = [NSData dataWithBytes:digest length:20];
    return AFEncodeBase64WithData(signatureData);
}

#pragma mark -

@interface AFXAuthClient ()
@property (copy, nonatomic, readonly) NSString *consumerKey;
@property (copy, nonatomic, readonly) NSString *consumerSecret;
@property (copy, nonatomic, readonly) NSString *username;
@property (copy, nonatomic, readonly) NSString *password;

- (NSString *)baseStringWithRequest:(NSURLRequest *)request;
- (NSString *)authorizationHeaderForParameters:(NSDictionary *)parameters;
@end


@implementation AFXAuthClient

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret
{
    self = [super initWithBaseURL:url];
    if (self) {
        _consumerKey = key;
        _consumerSecret = secret;
        _nonce = AFNounce();
    }
    return self;
}

- (NSString *)baseStringWithRequest:(NSURLRequest *)request
{
    NSString *oauth_consumer_key = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(self.consumerKey, NSUTF8StringEncoding);
    NSString *oauth_nonce = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(_nonce, NSUTF8StringEncoding);
    NSString *oauth_signature_method = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(@"HMAC-SHA1", NSUTF8StringEncoding);
    NSString *oauth_timestamp = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(_timestamp, NSUTF8StringEncoding);
    NSString *oauth_version = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(@"1.0", NSUTF8StringEncoding);
    NSString *x_auth_mode = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(@"client_auth", NSUTF8StringEncoding);
    NSString *x_auth_password = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(self.password, NSUTF8StringEncoding);
    NSString *x_auth_username = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(self.username, NSUTF8StringEncoding);
    
    NSArray *params = @[[NSString stringWithFormat:@"%@%%3D%@", @"oauth_consumer_key", oauth_consumer_key],
                        [NSString stringWithFormat:@"%@%%3D%@", @"oauth_nonce", oauth_nonce],
                        [NSString stringWithFormat:@"%@%%3D%@", @"oauth_signature_method", oauth_signature_method],
                        [NSString stringWithFormat:@"%@%%3D%@", @"oauth_timestamp", oauth_timestamp],
                        [NSString stringWithFormat:@"%@%%3D%@", @"oauth_version", oauth_version]];
    
    
    if (!self.token)
        params = [params arrayByAddingObjectsFromArray:@[[NSString stringWithFormat:@"%@%%3D%@", @"x_auth_mode", x_auth_mode],
                                                         [NSString stringWithFormat:@"%@%%3D%@", @"x_auth_password", AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(x_auth_password, NSUTF8StringEncoding)],
                                                         [NSString stringWithFormat:@"%@%%3D%@", @"x_auth_username", AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(x_auth_username, NSUTF8StringEncoding)]]];
    
    if (self.token)
        params = [params arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%%3D%@", @"oauth_token", AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(self.token.key, NSUTF8StringEncoding)], nil]];
    
    params = [params sortedArrayUsingSelector:@selector(compare:)];
    NSString *baseString = [@[request.HTTPMethod,
                            AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(request.URL.absoluteString, NSUTF8StringEncoding),
                            [params componentsJoinedByString:@"%26"]] componentsJoinedByString:@"&"];
    return baseString;
}

- (NSString *)authorizationHeaderForParameters:(NSDictionary *)parameters
{
    static NSString * const kAFOAuth1AuthorizationFormatString = @"OAuth %@";
    
    if (!parameters) {
        return nil;
    }
    
    NSArray *sortedComponents = [[AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding) componentsSeparatedByString:@"&"] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *mutableComponents = [NSMutableArray array];
    for (NSString *component in sortedComponents) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        [mutableComponents addObject:[NSString stringWithFormat:@"%@=\"%@\"", [subcomponents objectAtIndex:0], [subcomponents objectAtIndex:1]]];
    }
    
    return [NSString stringWithFormat:kAFOAuth1AuthorizationFormatString, [mutableComponents componentsJoinedByString:@", "]];
}

- (void)authorizeUsingXAuthWithAccessTokenPath:(NSString *)accessTokenPath
                                  accessMethod:(NSString *)accessMethod
                                      username:(NSString *)username
                                      password:(NSString *)password
                                       success:(void (^)(AFXAuthToken *accessToken))success
                                       failure:(void (^)(NSError *error))failure
{
    _username = username;
    _password = password;
    
    NSDictionary *parameters = @{@"x_auth_mode": @"client_auth",
                                 @"x_auth_password": self.password,
                                 @"x_auth_username": self.username};
    
    NSMutableURLRequest *request = [self requestWithMethod:accessMethod path:accessTokenPath parameters:parameters];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *queryString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        _token = [[AFXAuthToken alloc] initWithQueryString:queryString];
        if (success)
            success(_token);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - AFHTTPClient

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    _timestamp = [NSString stringWithFormat:@"%d", (int)(((float)([[NSDate date] timeIntervalSince1970])) + 0.5)];
    
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    NSMutableDictionary *authorizationHeader = [[NSMutableDictionary alloc] initWithDictionary:@{@"oauth_nonce": _nonce,
                                                                                      @"oauth_signature_method": @"HMAC-SHA1",
                                                                                      @"oauth_timestamp": _timestamp,
                                                                                      @"oauth_consumer_key": self.consumerKey,
                                                                                      @"oauth_signature": AFHMACSHA1Signature([self baseStringWithRequest:request], _consumerSecret, _token.secret),
                                                                                      @"oauth_version": @"1.0"}];
    
    if (self.token)
        [authorizationHeader setObject:AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(self.token.key, NSUTF8StringEncoding) forKey:@"oauth_token"];
    [request setValue:[self authorizationHeaderForParameters:authorizationHeader] forHTTPHeaderField:@"Authorization"];
    [request setHTTPShouldHandleCookies:NO];
    return request;
}

@end

#pragma mark -

@interface AFXAuthToken ()
@property (readwrite, nonatomic, copy) NSString *key;
@property (readwrite, nonatomic, copy) NSString *secret;
@end

@implementation AFXAuthToken
@synthesize key = _key;
@synthesize secret = _secret;

- (id)initWithQueryString:(NSString *)queryString
{
    if (!queryString || [queryString length] == 0) {
        return nil;
    }
    
    NSDictionary *attributes = AFParametersFromQueryString(queryString);
    return [self initWithKey:[attributes objectForKey:@"oauth_token"] secret:[attributes objectForKey:@"oauth_token_secret"]];
}

- (id)initWithKey:(NSString *)key
           secret:(NSString *)secret
{
    NSParameterAssert(key);
    NSParameterAssert(secret);
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.key = key;
    self.secret = secret;
    
    return self;
}

@end
