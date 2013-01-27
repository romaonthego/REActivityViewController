//
//  RETumblrActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETumblrActivity.h"
#import "REActivityViewController.h"

@implementation RETumblrActivity

- (id)init
{
    return [super initWithTitle:@"Tumblr"
                          image:[UIImage imageNamed:@"Icon_Tumblr"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        UIViewController *presenter = activityViewController.presentingController;
                        NSDictionary *userInfo = activityViewController.userInfo;
                        
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            REComposeViewController *controller = [[REComposeViewController alloc] init];
                            controller.title = @"Tumblr";
                            controller.navigationBar.tintColor = [UIColor colorWithRed:56/255.0f green:86/255.0f blue:114/255.0f alpha:1.0];
                            controller.completionHandler = ^(REComposeResult result){
                                presenter.modalPresentationStyle = UIModalPresentationFullScreen;
                            };
                            presenter.modalPresentationStyle = UIModalPresentationCurrentContext;
                            [presenter presentViewController:controller animated:YES completion:nil];
                        }];
                    }];
}

@end
