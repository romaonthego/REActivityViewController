//
//  REInstapaperActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REInstapaperActivity.h"
#import "REActivityViewController.h"

@implementation REInstapaperActivity

- (id)init
{
    self = [super initWithTitle:@"Save to Instapaper"
                          image:[UIImage imageNamed:@"Icon_Instapaper"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        UIViewController *presenter = activityViewController.presentingController;
                        NSDictionary *userInfo = activityViewController.userInfo;
                    }];
    
    return self;
}

@end
