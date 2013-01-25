//
//  REMapsActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REMapsActivity.h"
#import "REActivityViewController.h"

@implementation REMapsActivity

- (id)init
{
    self = [super initWithTitle:@"Open in Maps"
                          image:[UIImage imageNamed:@"Icon_Maps"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Maps = %@", userInfo);
                    }];
    
    return self;
}

@end
