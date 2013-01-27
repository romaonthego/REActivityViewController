//
//  REPocketActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REPocketActivity.h"
#import "REActivityViewController.h"

@implementation REPocketActivity

- (id)init
{
    return [super initWithTitle:@"Save to Pocket"
                          image:[UIImage imageNamed:@"Icon_Pocket"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        //UIViewController *presenter = activityViewController.presentingController;
                        //NSDictionary *userInfo = activityViewController.userInfo;
                        
                        
                    }];
}

@end
