//
//  REInstagramActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REInstagramActivity.h"
#import "REActivityViewController.h"

@implementation REInstagramActivity

- (id)init
{
    self = [super initWithTitle:@"Open in Instagram"
                          image:[UIImage imageNamed:@"Icon_Instagram"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Instagram = %@", userInfo);
                    }];
    
    return self;
}

@end
