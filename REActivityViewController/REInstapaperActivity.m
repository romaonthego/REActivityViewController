//
//  REInstapaperActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REInstapaperActivity.h"
#import "REActivityViewController.h"
#import "AFNetworking.h"
#import "REAuthViewController.h"
#import "SFHFKeychainUtils.h"

@implementation REInstapaperActivity

- (id)init
{
    return [super initWithTitle:@"Send to Instapaper"
                          image:[UIImage imageNamed:@"Icon_Instapaper"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        UIViewController *presenter = activityViewController.presentingController;
                        NSDictionary *userInfo = activityViewController.userInfo;
                        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"REInstapaperActivity_Username"]) {
                            [activityViewController dismissViewControllerAnimated:YES completion:^{
                                REAuthViewController *controller = [[REAuthViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                                controller.title = @"Instapaper";
                                controller.labels = @[NSLocalizedString(@"Username", @"Username"), NSLocalizedString(@"Password", @"Password"), NSLocalizedString(@"We never store your password.", @"We never store your password.")];
                                controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
                                    [self authenticateUsername:username password:password success:^{
                                        [controller dismissViewControllerAnimated:YES completion:nil];
                                        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"REInstapaperActivity_Username"];
                                        [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"REInstapaperActivity" updateExisting:YES error:nil];
                                        [self saveURL:[userInfo objectForKey:@"url"] title:[userInfo objectForKey:@"text"]];
                                    } error:^{
                                        [controller showLoginButton];
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Instapaper Log In", @"Instapaper Log In") message:NSLocalizedString(@"Please check your username and password. If you're sure they're correct, Instapaper may be temporarily experiencing problems. Please try again in a few minutes.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
                                        [alertView show];
                                    }];
                                };
                                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                                [presenter presentViewController:navigationController animated:YES completion:nil];
                            }];
                        } else {
                            [activityViewController dismissViewControllerAnimated:YES completion:nil];
                            [self saveURL:[userInfo objectForKey:@"url"] title:[userInfo objectForKey:@"text"]];
                        }
                    }];
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
