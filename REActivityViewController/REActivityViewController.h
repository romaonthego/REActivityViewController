//
//  REActivityViewController.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REActivityView.h"
#import "REActivities.h"

@interface REActivityViewController : UIViewController {
    UIView *_backgroundView;
}

@property (strong, readonly, nonatomic) NSArray *activities;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) REActivityView *activityView;
@property (weak, nonatomic) UIPopoverController *presentingPopoverController;
@property (weak, nonatomic) UIViewController *presentingController;

- (id)initWithViewController:(UIViewController *)viewController activities:(NSArray *)activities;

@end
