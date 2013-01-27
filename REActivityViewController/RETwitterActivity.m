//
//  RETwitterActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETwitterActivity.h"
#import "REActivityViewController.h"
#import <Twitter/Twitter.h>

@implementation RETwitterActivity

- (id)init
{
    return [super initWithTitle:@"Twitter"
                          image:[UIImage imageNamed:@"Icon_Twitter"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        UIViewController *presenter = activityViewController.presentingController;
                        NSDictionary *userInfo = activityViewController.userInfo;
                        
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            TWTweetComposeViewController *composeController = [[TWTweetComposeViewController alloc] init];
                            NSString *text = [userInfo objectForKey:@"text"];
                            UIImage *image = [userInfo objectForKey:@"image"];
                            NSURL *url = [userInfo objectForKey:@"url"];
                            if (text)
                                [composeController setInitialText:text];
                            if (image)
                                [composeController addImage:image];
                            if (url)
                                [composeController addURL:url];
                            [presenter presentModalViewController:composeController animated:YES];
                        }];
                    }];
}

@end
