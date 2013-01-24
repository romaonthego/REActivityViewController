//
//  REMessageActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REMessageActivity.h"
#import "REActivityViewController.h"

@implementation REMessageActivity

- (id)init
{
    self = [super initWithTitle:@"Message"
                          image:[UIImage imageNamed:@"Icon_Message"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Message = %@", userInfo);
                    }];
    
    return self;
}

@end
