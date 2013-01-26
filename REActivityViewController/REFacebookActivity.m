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
    if (text)
        [facebookViewComposer setInitialText:text];
    if (url)
        [facebookViewComposer addURL:url];
    if (image)
        [facebookViewComposer addImage:image];
    [viewController presentViewController:facebookViewComposer animated:YES completion:nil];
}

@end
