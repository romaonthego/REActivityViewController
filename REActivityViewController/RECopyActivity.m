//
//  RECopyActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RECopyActivity.h"
#import "REActivityViewController.h"

@implementation RECopyActivity

- (id)init
{
    self = [super initWithTitle:@"Copy"
                          image:[UIImage imageNamed:@"Icon_Copy"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Copy = %@", userInfo);
                    }];
    
    return self;
}

@end
