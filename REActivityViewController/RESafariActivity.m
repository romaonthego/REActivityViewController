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
    self = [super initWithTitle:@"Open in Safari"
                          image:[UIImage imageNamed:@"Icon_Safari"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Safari = %@", userInfo);
                    }];
    
    return self;
}

@end
