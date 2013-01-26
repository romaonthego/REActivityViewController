//
//  REActivityViewController.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REActivityView.h"
#import "REActivity.h"
#import "REFacebookActivity.h"
#import "RETwitterActivity.h"
#import "REMessageActivity.h"
#import "REMailActivity.h"
#import "REPrintActivity.h"
#import "RECopyActivity.h"
#import "RESafariActivity.h"
#import "REMapsActivity.h"
#import "RESaveToAlbumActivity.h"

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
