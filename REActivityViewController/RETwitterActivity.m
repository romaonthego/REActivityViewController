//
//  RETwitterActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETwitterActivity.h"
#import "REActivityViewController.h"

@implementation RETwitterActivity

- (id)init
{
    self = [super initWithTitle:@"Twitter"
                          image:[UIImage imageNamed:@"Icon_Twitter"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Twitter = %@", userInfo);
                    }];
    
    return self;
}

@end
