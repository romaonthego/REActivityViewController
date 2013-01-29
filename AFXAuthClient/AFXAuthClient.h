//
// AFXAuthClient.h
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

#import "AFHTTPClient.h"

@class AFXAuthToken;

@interface AFXAuthClient : AFHTTPClient {
    NSString *_nonce;
    NSString *_timestamp;
}

///-----------------------------------
/// @name Managing OAuth Configuration
///-----------------------------------

/**

 */
@property (copy, nonatomic, readonly) AFXAuthToken *token;

///---------------------
/// @name Initialization
///---------------------

/**

 */
- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret;

///---------------------
/// @name Authenticating
///---------------------


/**

 */
- (void)authorizeUsingXAuthWithAccessTokenPath:(NSString *)accessTokenPath
                                  accessMethod:(NSString *)accessMethod
                                      username:(NSString *)username
                                      password:(NSString *)password
                                       success:(void (^)(AFXAuthToken *accessToken))success
                                       failure:(void (^)(NSError *error))failure;

@end

#pragma mark -

/**

 */
@interface AFXAuthToken : NSObject

/**

 */
@property (readonly, nonatomic, copy) NSString *key;

/**

 */
@property (readonly, nonatomic, copy) NSString *secret;

/**

 */
- (id)initWithQueryString:(NSString *)queryString;

/**

 */
- (id)initWithKey:(NSString *)key
           secret:(NSString *)secret;

@end