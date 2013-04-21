//
// REDiigoActivity.m
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

#import "REDiigoActivity.h"
#import "REActivityViewController.h"
#import "REAuthViewController.h"
#import "SFHFKeychainUtils.h"
#import "AFNetworking.h"

@implementation REDiigoActivity

- (id)initWithAPIKey:(NSString *)apiKey
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Diigo.title", @"REActivityViewController", @"Save to Diigo")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Diigo"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    _apiKey = apiKey;
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"REDiigoActivity_Username"]) {
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
        controller.title = NSLocalizedStringFromTable(@"activity.Diigo.authentication.title", @"REActivityViewController", @"Diigo");
        controller.labels = @[
                              NSLocalizedStringFromTable(@"field.username", @"REActivityViewController", @"Username"),
                              NSLocalizedStringFromTable(@"field.password", @"REActivityViewController", @"Password"),
                              NSLocalizedStringFromTable(@"slogan.password.storage.is.safe", @"REActivityViewController", @"We store your password in safe place.")
                              ];
        controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
            [weakSelf authenticateWithUsername:username password:password success:^ {
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"REDiigoActivity_Username"];
                [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"REDiigoActivity" updateExisting:YES error:nil];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [controller dismissViewControllerAnimated:YES completion:^{
                    [weakSelf bookmark:userInfo];
                }];
            } failure:^(NSError *error) {
                [controller showLoginButton];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Diigo.authentication.title", @"REActivityViewController", @"Diigo")
                                                                    message:NSLocalizedStringFromTable(@"activity.Diigo.authentication.error", @"REActivityViewController", @"Please check your username and password. If you're sure they're correct, Diigo may be temporarily experiencing problems. Please try again in a few minutes.")
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

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://secure.diigo.com"]];
    [client setAuthorizationHeaderWithUsername:username password:password];
    [client getPath:@"/api/v2/bookmarks" parameters:@{@"key": _apiKey} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
            success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
}

- (void)bookmark:(NSDictionary *)userInfo
{
    __typeof(&*self) __weak weakSelf = self;
    
    NSString *text = [userInfo objectForKey:@"text"];
    NSURL *url = [userInfo objectForKey:@"url"];
    
    REComposeViewController *controller = [[REComposeViewController alloc] init];
    controller.title = NSLocalizedStringFromTable(@"activity.Diigo.dialog.title", @"REActivityViewController", @"Diigo");
    controller.navigationBar.tintColor = [UIColor colorWithRed:11/255.0f green:95/255.0f blue:160/255.0f alpha:1.0];
    controller.text = text;
    controller.hasAttachment = YES;
    controller.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        if (result == REComposeResultPosted) {
            if (!composeViewController.text || [composeViewController.text isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Diigo.error.title", @"REActivityViewController", @"Error.")
                                                                message:NSLocalizedStringFromTable(@"activity.Diigo.error.text", @"REActivityViewController", @"Please enter title.")
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedStringFromTable(@"button.dismiss", @"REActivityViewController", @"Dismiss")
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                [composeViewController dismissViewControllerAnimated:YES completion:nil];
                
                AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://secure.diigo.com"]];
                NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"REDiigoActivity_Username"];
                NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"REDiigoActivity" error:nil];
                [client setAuthorizationHeaderWithUsername:username
                                                  password:password];
                [client postPath:@"/api/v2/bookmarks"
                     parameters:@{@"key": _apiKey, @"title": composeViewController.text, @"url": url.absoluteString}
                        success:nil
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Diigo.authentication.title", @"REActivityViewController", @"Diigo")
                                                                                message:NSLocalizedStringFromTable(@"activity.Diigo.authentication.error", @"REActivityViewController", @"Please check your username and password. If you're sure they're correct, Diigo may be temporarily experiencing problems. Please try again in a few minutes.")
                                                                               delegate:nil
                                                                      cancelButtonTitle:NSLocalizedStringFromTable(@"button.dismiss", @"REActivityViewController", @"Dismiss")
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"REDiigoActivity_Username"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [weakSelf showAuthDialogWithActivityViewController:weakSelf.activityViewController];
                        }];
            }
        } else {
            [composeViewController dismissViewControllerAnimated:YES completion:nil];
        }
    };
    UIViewController *presentingViewController = self.activityViewController.rootViewController ? self.activityViewController.rootViewController : self.activityViewController.presentingController;
    [controller presentFromViewController:presentingViewController];
}

@end
