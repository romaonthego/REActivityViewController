//
// REInstapaperActivity.m
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

#import "REInstapaperActivity.h"
#import "REActivityViewController.h"
#import "AFNetworking.h"
#import "REAuthViewController.h"
#import "SFHFKeychainUtils.h"

@implementation REInstapaperActivity

- (id)init
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Instapaper.title", @"REActivityViewController", @"Send to Instapaper")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Instapaper"]
                    actionBlock:nil];
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        UIViewController *presenter = activityViewController.presentingController;
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"REInstapaperActivity_Username"]) {
            [activityViewController dismissViewControllerAnimated:YES completion:^{
                REAuthViewController *controller = [[REAuthViewController alloc] initWithStyle:UITableViewStyleGrouped];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                controller.title = NSLocalizedStringFromTable(@"activity.Instapaper.authentication.title", @"REActivityViewController", @"Instapaper");
                controller.labels = @[
                                      NSLocalizedStringFromTable(@"field.username", @"REActivityViewController", @"Username"),
                                      NSLocalizedStringFromTable(@"field.password", @"REActivityViewController", @"Password"),
                                      NSLocalizedStringFromTable(@"slogan.never.store.password", @"REActivityViewController", @"We never store your password.")
                                      ];
                controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
                    [weakSelf authenticateUsername:username password:password success:^{
                        [controller dismissViewControllerAnimated:YES completion:nil];
                        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"REInstapaperActivity_Username"];
                        if ([SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"REInstapaperActivity" updateExisting:YES error:nil]) {
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        [weakSelf saveURL:[userInfo objectForKey:@"url"] title:[userInfo objectForKey:@"text"]];
                    } error:^{
                        [controller showLoginButton];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Instapaper.authentication.title", @"REActivityViewController", @"Instapaper")
                                                                            message:NSLocalizedStringFromTable(@"activity.Instapaper.authentication.error", @"REActivityViewController", @"Please check your username and password. If you're sure they're correct, Instapaper may be temporarily experiencing problems. Please try again in a few minutes.")
                                                                           delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"button.dismiss", @"REActivityViewController", @"Dismiss") otherButtonTitles:nil];
                        [alertView show];
                    }];
                };
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                [presenter presentViewController:navigationController animated:YES completion:nil];
            }];
        } else {
            [activityViewController dismissViewControllerAnimated:YES completion:nil];
            [weakSelf saveURL:[userInfo objectForKey:@"url"] title:[userInfo objectForKey:@"text"]];
        }
    };
    
    return self;
}

- (void)authenticateUsername:(NSString *)username password:(NSString *)password success:(void (^)(void))onSuccess error:(void (^)(void))onError
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.instapaper.com/api/authenticate"]];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    [httpClient postPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (onSuccess)
            onSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (onError)
            onError();
    }];
}

- (void)saveURL:(NSURL *)url title:(NSString *)title
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"REInstapaperActivity_Username"];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"REInstapaperActivity" error:nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.instapaper.com/api/add"]];
    [httpClient setAuthorizationHeaderWithUsername:username password:password];
    NSDictionary *params = @{
        @"title": title ? title : @"",
        @"url": url.absoluteString
    };
    [httpClient postPath:@"" parameters:params success:nil failure:nil];
}

@end
