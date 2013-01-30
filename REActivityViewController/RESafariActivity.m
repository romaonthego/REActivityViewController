//
//  RESafariActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RESafariActivity.h"
#import "REActivityViewController.h"

@implementation RESafariActivity

- (id)init
{
    return [super initWithTitle:@"Open in Safari"
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Safari"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        
                        if ([[userInfo objectForKey:@"url"] isKindOfClass:[NSURL class]])
                            [[UIApplication sharedApplication] openURL:[userInfo objectForKey:@"url"]];
                    }];
}

@end
