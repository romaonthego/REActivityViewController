//
// REKipptActivity.m
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

#import "REKipptActivity.h"
#import "REActivityViewController.h"
#import "REAuthViewController.h"
#import "SFHFKeychainUtils.h"
#import "AFNetworking.h"

@implementation REKipptActivity

- (id)init
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Kippt.title", @"REActivityViewController", @"Save to Kippt")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Kippt"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"REKipptActivity_Username"]) {
            [weakSelf showAuthDialogWithActivityViewController:activityViewController];
        } else {
            [activityViewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf postUserInfo:userInfo success:nil failure:^(NSError *error) {
                    [weakSelf showAuthDialogWithActivityViewController:activityViewController];
                }];
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
        controller.title = NSLocalizedStringFromTable(@"activity.Kiipt.authentication.title", @"REActivityViewController", @"Kippt");
        controller.labels = @[
                              NSLocalizedStringFromTable(@"field.username", @"REActivityViewController", @"Username"),
                              NSLocalizedStringFromTable(@"field.password", @"REActivityViewController", @"Password"),
                              NSLocalizedStringFromTable(@"slogan.password.storage.is.safe", @"REActivityViewController", @"We store your password in safe place.")
                              ];
        controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
            [weakSelf postWithUsername:username password:password userInfo:userInfo success:^{
                [controller dismissViewControllerAnimated:YES completion:nil];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"REKipptActivity_Username"];
                [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"REKipptActivity" updateExisting:YES error:nil];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } failure:^(NSError *error) {
                [controller showLoginButton];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Kippt.authentication.title", @"REActivityViewController", @"Kippt")
                                                                    message:NSLocalizedStringFromTable(@"activity.Kippt.authentication.error", @"REActivityViewController", @"Please check your username and password. If you're sure they're correct, Kippt may be temporarily experiencing problems. Please try again in a few minutes.")
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

- (void)postWithUsername:(NSString *)username password:(NSString *)password userInfo:(NSDictionary *)userInfo success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSURL *url = [userInfo objectForKey:@"url"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://kippt.com"]];
    [client setAuthorizationHeaderWithUsername:username password:password];
    client.parameterEncoding = AFJSONParameterEncoding;
    NSURLRequest *request = [client requestWithMethod:@"POST" path:@"/api/clips" parameters:@{@"url": url.absoluteString}];
	AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
            success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
    [client enqueueHTTPRequestOperation:operation];
}

- (void)postUserInfo:(NSDictionary *)userInfo success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"REKipptActivity_Username"];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"REKipptActivity" error:nil];
    [self postWithUsername:username password:password userInfo:userInfo success:success failure:failure];
}

@end
