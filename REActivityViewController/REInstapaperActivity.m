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

@implementation REInstapaperActivity

- (id)init
{
    return [super initWithTitle:@"Send to Instapaper"
                          image:[UIImage imageNamed:@"Icon_Instapaper"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        UIViewController *presenter = activityViewController.presentingController;
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            REAuthViewController *controller = [[REAuthViewController alloc] initWithStyle:UITableViewStyleGrouped];
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                            controller.title = @"Instapaper";
                            controller.labels = @[NSLocalizedString(@"Username", @"Username"), NSLocalizedString(@"Password", @"Password")];
                            controller.onLoginButtonPressed = ^(REAuthViewController *controller, NSString *username, NSString *password) {
                                NSLog(@"username = %@, password = %@", username, password);
                                //[controller showLoginButton];
                                [self authenticateUsername:username password:password success:^{
                                    [controller dismissViewControllerAnimated:YES completion:nil];
                                } error:^{
                                    [controller showLoginButton];
                                }];
                            };
                            [presenter presentViewController:navigationController animated:YES completion:nil];
                        }];
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
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.instapaper.com/api/add"]];
    [httpClient setAuthorizationHeaderWithUsername:@"romefimov@gmail.com" password:@""];
    NSDictionary *params = @{
        @"title": title ? title : @"",
        @"url": url.absoluteString
    };
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

@end
