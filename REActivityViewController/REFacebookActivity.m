//
//  REFacebookActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REFacebookActivity.h"
#import "REActivityViewController.h"

@implementation REFacebookActivity

- (id)init
{
    self = [super initWithTitle:@"Facebook"
                          image:[UIImage imageNamed:@"Icon_Facebook"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Facebook = %@", userInfo);
                    }];
    
    return self;
}

@end
