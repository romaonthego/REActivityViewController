//
// REReadabilityActivity.m
// REActivityViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
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

#import "REReadabilityActivity.h"
#import "REActivityViewController.h"
#import "REAuthViewController.h"
#import "SFHFKeychainUtils.h"
#import "AFNetworking.h"
#import "AFXAuthClient.h"

@implementation REReadabilityActivity

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Readability.title", @"REActivityViewController", @"Save to Readability")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Readability"]
                    actionBlock:nil];
    if (!self)
        return nil;
    
    _consumerKey = consumerKey;
    _consumerSecret = consumerSecret;
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"REReadabilityActivity_Key"]) {
            [weakSelf showAuthDialogWithActivityViewController:activityViewController];
        } else {
            [activityViewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf bookmark:userInfo];
            }];
        }
    };
    
    return self;
}

- (void)showAuthDialogWithActivityViewController:(REActivityViewController *)activityViewController
{
    __typeof(&*self) __weak weakSelf = self;
    
    UIViewController *presenter = activityViewController.presentingController;
    NSDictionary *userInfo = self.userInfo ? self.userInfo : activityViewController.userInfo;
    [activityViewController dismissViewControllerAnimated:YES completion:^{
        REAuthViewController *controller = [[REAuthViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = NSLocalizedStringFromTable(@"activity.Readability.authentication.title", @"REActivityViewController", @"Readability");
        controller.labels = @[
                              NSLocalizedStringFromTable(@"field.username", @"REActivityViewController", @"Username"),
                              NSLocalizedStringFromTable(@"field.password", @"REActivityViewController", @"Password"),
                              NSLocalizedStringFromTable(@"slogan.never.store.password", @"REActivityViewController", @"We never store your password.")
                              ];
        controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
            [weakSelf authenticateWithUsername:username password:password success:^(AFXAuthClient *client) {
                [[NSUserDefaults standardUserDefaults] setObject:client.token.key forKey:@"REReadabilityActivity_Key"];
                [[NSUserDefaults standardUserDefaults] setObject:client.token.secret forKey:@"REReadabilityActivity_Secret"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [controller dismissViewControllerAnimated:YES completion:^{
                    [weakSelf bookmark:userInfo];
                }];
            } failure:^(NSError *error) {
                [controller showLoginButton];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Readability.authentication.title", @"REActivityViewController", @"Readability")
                                                                    message:NSLocalizedStringFromTable(@"activity.Readability.authentication.error", @"REActivityViewController", @"Please check your username and password. If you're sure they're correct, Readability may be temporarily experiencing problems. Please try again in a few minutes.")
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedStringFromTable(@"button.dismiss", @"REActivityViewController", @"Dismiss")
                                                          otherButtonTitles:nil];
                [alertView show];
            }];
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [presenter presentViewController:navigationController animated:YES completion:nil];
    }];
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(AFXAuthClient *client))success failure:(void (^)(NSError *error))failure
{
    AFXAuthClient *client = [[AFXAuthClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.readability.com"]
                                                               key:_consumerKey
                                                            secret:_consumerSecret];
    
    [client authorizeUsingXAuthWithAccessTokenPath:@"/api/rest/v1/oauth/access_token"
                                      accessMethod:@"POST"
                                          username:username
                                          password:password
                                           success:^(AFXAuthToken *accessToken) {
                                               if (success)
                                                   success(client);
                                           } failure:failure];
}

- (void)bookmark:(NSDictionary *)userInfo
{
    AFXAuthClient *client = [[AFXAuthClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.readability.com"]
                                                               key:_consumerKey
                                                            secret:_consumerSecret];
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"REReadabilityActivity_Key"];
    NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"REReadabilityActivity_Secret"];
    client.token = [[AFXAuthToken alloc] initWithKey:key secret:secret];
    
    NSURL *url = [userInfo objectForKey:@"url"];
    NSDictionary *parameters = @{@"url": url.absoluteString};
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/api/rest/v1/bookmarks" parameters:parameters];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
    [client enqueueHTTPRequestOperation:operation];
}

@end
