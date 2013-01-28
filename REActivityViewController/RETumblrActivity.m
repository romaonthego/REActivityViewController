//
//  RETumblrActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETumblrActivity.h"
#import "REActivityViewController.h"
#import "REAuthViewController.h"
#import "SFHFKeychainUtils.h"
#import "AFNetworking.h"
#import "AFOAuth1Client.h"

@implementation RETumblrActivity

- (id)init
{
    return [super initWithTitle:@"Tumblr"
                          image:[UIImage imageNamed:@"Icon_Tumblr"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        /*UIViewController *presenter = activityViewController.presentingController;
                       // NSDictionary *userInfo = activityViewController.userInfo;
                        
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            REComposeViewController *controller = [[REComposeViewController alloc] init];
                            controller.title = @"Tumblr";
                            controller.navigationBar.tintColor = [UIColor colorWithRed:56/255.0f green:86/255.0f blue:114/255.0f alpha:1.0];
                            controller.completionHandler = ^(REComposeResult result){
                                presenter.modalPresentationStyle = UIModalPresentationFullScreen;
                            };
                            presenter.modalPresentationStyle = UIModalPresentationCurrentContext;
                            [presenter presentViewController:controller animated:YES completion:nil];
                        }];*/
                        
                       // UIViewController *presenter = activityViewController.presentingController;
                       // NSDictionary *userInfo = activityViewController.userInfo;
                        /*if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RETumblrActivity_Email"]) {
                            [activityViewController dismissViewControllerAnimated:YES completion:^{
                                REAuthViewController *controller = [[REAuthViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                                controller.title = @"Tumblr";
                                controller.labels = @[NSLocalizedString(@"Email", @"Email"), NSLocalizedString(@"Password", @"Password"), NSLocalizedString(@"We never store your password.", @"We never store your password.")];
                                controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
                                    [self authenticateUsername:username password:password success:^{
                                        [controller dismissViewControllerAnimated:YES completion:nil];
                                        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"RETumblrActivity_Username"];
                                        [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"RETumblrActivity" updateExisting:YES error:nil];
                                        [self shareUserInfo:userInfo];
                                    } error:^{
                                        [controller showLoginButton];
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tumblr Log In", @"Tumblr Log In") message:NSLocalizedString(@"Please check your e-mail and password. If you're sure they're correct, Instapaper may be temporarily experiencing problems. Please try again in a few minutes.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
                                        [alertView show];
                                    }];
                                };
                                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                                [presenter presentViewController:navigationController animated:YES completion:nil];
                            }];
                        } else {
                            [activityViewController dismissViewControllerAnimated:YES completion:nil];
                            [self shareUserInfo:userInfo];
                        }*/
                        
                        AFOAuth1Client *client = [[AFOAuth1Client alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.tumblr.com"]
                                                                                     key:@"ISY7GdYtCDXfzo4hSfWTlaAVmkRreLBttE15Igedfr4sfaAYxW"
                                                                                  secret:@"JX994q7T9va9Rm6VNgrMw6hiLgllEQzhsB2T7TtXWhN5yYj2IZ"];
                        
                        
                        
                        [client authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token"
                                                  userAuthorizationPath:@"/oauth/authorize"
                                                            callbackURL:[NSURL URLWithString:@"testapp://success"]
                                                        accessTokenPath:@"/oauth/access_token"
                                                           accessMethod:@"POST"
                                                                success:^(AFOAuth1Token *accessToken) {
                                                                    NSLog(@"Success: %@", accessToken);
                                                                } failure:^(NSError *error) {
                                                                    NSLog(@"Error: %@", error);
                                                                }];
                    }];
}

- (void)shareUserInfo:(NSDictionary *)userInfo
{
    UIViewController *presenter = self.activityViewController.presentingController;
    
    NSString *text = [userInfo objectForKey:@"text"];
    NSURL *url = [userInfo objectForKey:@"url"];
    UIImage *image = [userInfo objectForKey:@"image"];
    
    NSString *textToShare;
    if (text && !url)
        textToShare = text;
    
    if (!text && url)
        textToShare = url.absoluteString;
    
    if (text && url)
        textToShare = [NSString stringWithFormat:@"%@ %@", text, url.absoluteString];
    
    REComposeViewController *controller = [[REComposeViewController alloc] init];
    controller.title = @"Tumblr";
    controller.navigationBar.tintColor = [UIColor colorWithRed:56/255.0f green:86/255.0f blue:114/255.0f alpha:1.0];
    if (textToShare)
        controller.text = textToShare;
    if (image) {
        controller.hasAttachment = YES;
        controller.attachmentImage = image;
    }
    controller.completionHandler = ^(REComposeResult result){
        presenter.modalPresentationStyle = UIModalPresentationFullScreen;
        if (result == REComposeResultPosted) {
            
        }
    };
    presenter.modalPresentationStyle = UIModalPresentationCurrentContext;
    [presenter presentViewController:controller animated:YES completion:nil];
}

@end
