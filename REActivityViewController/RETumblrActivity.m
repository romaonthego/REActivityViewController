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
#import "AFXAuthClient.h"

@implementation RETumblrActivity

- (id)init
{
    return [super initWithTitle:@"Tumblr"
                          image:[UIImage imageNamed:@"Icon_Tumblr"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        NSDictionary *userInfo = activityViewController.userInfo;
                        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RETumblrActivity_Email"]) {
                            [self showAuthDialogWithActivityViewController:activityViewController];
                        } else {
                            [activityViewController dismissViewControllerAnimated:YES completion:^{
                                NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"RETumblrActivity_Email"];
                                NSString *password = [SFHFKeychainUtils getPasswordForUsername:email andServiceName:@"RETumblrActivity" error:nil];
                                
                                [self authenticateWithUsername:email
                                                      password:password success:^(AFXAuthClient *client) {
                                                          [self shareUserInfo:userInfo client:client];
                                                      } failure:^(NSError *error) {
                                                          [self showAuthDialogWithActivityViewController:activityViewController];
                                                          
                                                          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tumblr Log In", @"Tumblr Log In") message:NSLocalizedString(@"Please check your e-mail and password. If you're sure they're correct, Tumblr may be temporarily experiencing problems. Please try again in a few minutes.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
                                                          [alertView show];
                                                      }];
                            }];
                        }
                    }];
}

- (void)showAuthDialogWithActivityViewController:(REActivityViewController *)activityViewController
{
    UIViewController *presenter = activityViewController.presentingController;
    NSDictionary *userInfo = activityViewController.userInfo;
    [activityViewController dismissViewControllerAnimated:YES completion:^{
        REAuthViewController *controller = [[REAuthViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = @"Tumblr";
        controller.labels = @[NSLocalizedString(@"Email", @"Email"), NSLocalizedString(@"Password", @"Password"), NSLocalizedString(@"We store your password in safe place.", @"We store your password in safe place.")];
        controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
            [self authenticateWithUsername:username password:password success:^(AFXAuthClient *client) {
                [controller dismissViewControllerAnimated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"RETumblrActivity_Email"];
                    [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"RETumblrActivity" updateExisting:YES error:nil];
                    [self shareUserInfo:userInfo client:client];
                }];
            } failure:^(NSError *error) {
                [controller showLoginButton];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tumblr Log In", @"Tumblr Log In") message:NSLocalizedString(@"Please check your e-mail and password. If you're sure they're correct, Tumblr may be temporarily experiencing problems. Please try again in a few minutes.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"Dismiss") otherButtonTitles:nil];
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
    AFXAuthClient *client = [[AFXAuthClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.tumblr.com"]
                                                               key:@"o4bYX0gVoi6RcOHCo8FAPgHE07cEMo094j8xSFSM83MG7jQVDq"
                                                            secret:@""];
    
    [client authorizeUsingXAuthWithAccessTokenPath:@"/oauth/access_token"
                                      accessMethod:@"POST"
                                          username:username
                                          password:password
                                           success:^(AFXAuthToken *accessToken) {                                               
                                               if (success)
                                                   success(client);
                                           } failure:failure];
}

- (void)shareUserInfo:(NSDictionary *)userInfo client:(AFXAuthClient *)client
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
    controller.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
        
        presenter.modalPresentationStyle = UIModalPresentationFullScreen;
        if (result == REComposeResultPosted) {
            NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/v2/user/info" parameters:nil];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"Info: %@", JSON);
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"Error: %@", error);
            }];
            [client enqueueHTTPRequestOperation:operation];
        }
    };
    presenter.modalPresentationStyle = UIModalPresentationCurrentContext;
    [presenter presentViewController:controller animated:YES completion:nil];
}

@end
