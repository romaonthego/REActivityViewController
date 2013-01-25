//
//  REPrintActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REPrintActivity.h"
#import "REActivityViewController.h"

@implementation REPrintActivity

- (id)init
{
    self = [super initWithTitle:@"Print"
                          image:[UIImage imageNamed:@"Icon_Print"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Print = %@", userInfo);
                    }];
    
    return self;
}

@end
