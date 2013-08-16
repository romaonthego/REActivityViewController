//
// RETumblrActivity.m
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

#import "RETumblrActivity.h"
#import "REActivityViewController.h"
#import "REAuthViewController.h"
#import "SFHFKeychainUtils.h"
#import "AFNetworking.h"
#import "AFXAuthClient.h"

@implementation RETumblrActivity

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Tumblr.title", @"REActivityViewController", @"Tumblr")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Tumblr"]
                    actionBlock:nil];
    if (!self)
        return nil;
    
    _consumerKey = consumerKey;
    _consumerSecret = consumerSecret;
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RETumblrActivity_Email"]) {
            [weakSelf showAuthDialogWithActivityViewController:activityViewController];
        } else {
            [activityViewController dismissViewControllerAnimated:YES completion:^{
                NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"RETumblrActivity_Email"];
                NSString *password = [SFHFKeychainUtils getPasswordForUsername:email andServiceName:@"RETumblrActivity" error:nil];
                
                [weakSelf authenticateWithUsername:email
                                      password:password success:^(AFXAuthClient *client) {
                                          [weakSelf shareUserInfo:userInfo client:client];
                                      } failure:^(NSError *error) {
                                          [weakSelf showAuthDialogWithActivityViewController:activityViewController];
                                          [weakSelf showAuthErrorAlert];
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
        controller.title = NSLocalizedStringFromTable(@"activity.Tumblr.authentication.title", @"REActivityViewController", @"Tumblr");
        controller.labels = @[
                              NSLocalizedStringFromTable(@"field.email", @"REActivityViewController", @"Email"),
                              NSLocalizedStringFromTable(@"field.password", @"REActivityViewController", @"Password"),
                              NSLocalizedStringFromTable(@"slogan.password.storage.is.safe", @"REActivityViewController", @"We store your password in safe place.")
                              ];
        controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {            
            [weakSelf authenticateWithUsername:username password:password success:^(AFXAuthClient *client) {
                NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"http://api.tumblr.com/v2/user/info" parameters:nil];
                AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    NSDictionary *blog = [[[[JSON objectForKey:@"response"] objectForKey:@"user"] objectForKey:@"blogs"] objectAtIndex:0];
                    NSURL *url = [NSURL URLWithString:[blog objectForKey:@"url"]];
                  
                    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"RETumblrActivity_Email"];
                    [[NSUserDefaults standardUserDefaults] setObject:url.host forKey:@"RETumblrActivity_Blog"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"RETumblrActivity" updateExisting:YES error:nil];
                    
                    [controller dismissViewControllerAnimated:YES completion:^{
                        [weakSelf shareUserInfo:userInfo client:client];
                    }];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    [weakSelf showAuthErrorAlert];
                }];
                [client enqueueHTTPRequestOperation:operation];
            } failure:^(NSError *error) {
                [controller showLoginButton];
                [weakSelf showAuthErrorAlert];
            }];
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [presenter presentViewController:navigationController animated:YES completion:nil];
    }];
}

- (void)showAuthErrorAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Tumblr.authentication.title", @"REActivityViewController", @"Tumblr")
                                                        message:NSLocalizedStringFromTable(@"activity.Tumblr.authentication.error", @"REActivityViewController", @"Please check your e-mail and password. If you're sure they're correct, Tumblr may be temporarily experiencing problems. Please try again in a few minutes.")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"button.dismiss", @"REActivityViewController", @"Dismiss")
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(AFXAuthClient *client))success failure:(void (^)(NSError *error))failure
{
    AFXAuthClient *client = [[AFXAuthClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.tumblr.com"]
                                                               key:_consumerKey
                                                            secret:_consumerSecret];
    
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
    __typeof(&*self) __weak weakSelf = self;

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
    controller.title = NSLocalizedStringFromTable(@"activity.Tumblr.dialog.title", @"REActivityViewController", @"Tumblr");
    controller.navigationBar.tintColor = [UIColor colorWithRed:56/255.0f green:86/255.0f blue:114/255.0f alpha:1.0];
    if (textToShare)
        controller.text = textToShare;
    if (image) {
        controller.hasAttachment = YES;
        controller.attachmentImage = image;
    }
    controller.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
        if (result == REComposeResultPosted) {
            if (image) {
                [weakSelf shareUsingClient:client text:composeViewController.text image:image];
            } else {
                [weakSelf shareUsingClient:client text:composeViewController.text];
            }
        }
    };
    UIViewController *presentingViewController = self.activityViewController.rootViewController ? self.activityViewController.rootViewController : self.activityViewController.presentingController;
    [controller presentFromViewController:presentingViewController];
}

- (void)shareUsingClient:(AFXAuthClient *)client text:(NSString *)text
{
    NSString *hostName = [[NSUserDefaults standardUserDefaults] objectForKey:@"RETumblrActivity_Blog"];    
    NSDictionary *parameters = @{@"type": @"text", @"body": text};
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", hostName] parameters:parameters];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
    [client enqueueHTTPRequestOperation:operation];
}

- (void)shareUsingClient:(AFXAuthClient *)client text:(NSString *)text image:(UIImage *)image
{
    NSString *hostName = [[NSUserDefaults standardUserDefaults] objectForKey:@"RETumblrActivity_Blog"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
    
    NSDictionary *parameters = @{@"type": @"photo", @"caption": text};
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/post", hostName] parameters:parameters
                                                    constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
                                                        [formData appendPartWithFileData:imageData name:@"data" fileName:@"photo.jpg" mimeType:@"image/jpg"];
                                                    }];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
    [client enqueueHTTPRequestOperation:operation];
}

@end
