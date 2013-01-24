//
//  REMailActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REMailActivity.h"
#import "REActivityViewController.h"

@implementation REMailActivity

- (id)init
{
    self = [super initWithTitle:@"Mail"
                          image:[UIImage imageNamed:@"Icon_Mail"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Send mail = %@", userInfo);
    }];
    
    return self;
}

@end
