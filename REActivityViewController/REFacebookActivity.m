//
//  REFacebookActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REFacebookActivity.h"
#import "REActivityViewController.h"
#import "DEFacebookComposeViewController.h"

@implementation REFacebookActivity

- (id)init
{
    self = [super initWithTitle:@"Facebook"
                          image:[UIImage imageNamed:@"Icon_Facebook"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        UIViewController *presenter = activityViewController.presentingController;
                        NSDictionary *userInfo = activityViewController.userInfo;
                        
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            [self shareFromViewController:presenter
                                                     text:[userInfo objectForKey:@"text"]
                                                      url:[userInfo objectForKey:@"url"]
                                                    image:[userInfo objectForKey:@"image"]];
                        }];
                    }];
    
    return self;
}

- (void)shareFromViewController:(UIViewController *)viewController text:(NSString *)text url:(NSURL *)url image:(UIImage *)image
{
    DEFacebookComposeViewController *facebookViewComposer = [[DEFacebookComposeViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [facebookViewComposer setInitialText:text];
    [facebookViewComposer addURL:url];
    /*if ([[UIDevice currentDevice].systemVersion floatValue] >= 6) {
        [facebookViewComposer addURL:(NSString *)url];
    } else {
        [facebookViewComposer addURL:[url absoluteString]];
    }*/
    [viewController presentViewController:facebookViewComposer animated:YES completion:nil];
}

- (void)iOS6_shareOnFacebookUsingPresenter:(UIViewController *)presenter userInfo:(NSDictionary *)userInfo
{
   /* SLComposeViewController *composeController = [[SLComposeViewController alloc] init];
    composeController.
    NSString *text = [userInfo objectForKey:@"text"];
    UIImage *image = [userInfo objectForKey:@"image"];
    NSURL *url = [userInfo objectForKey:@"url"];
    if (text)
        [composeController setInitialText:text];
    if (image)
        [composeController addImage:image];
    if (url)
        [composeController addURL:url];
    [presenter presentModalViewController:composeController animated:YES];*/
}

@end
