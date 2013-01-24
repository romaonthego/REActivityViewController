//
//  REActivityViewController.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REActivity.h"
#import "REFacebookActivity.h"
#import "RETwitterActivity.h"

@interface REActivityViewController : UIViewController

- (id)initWithActivities:(NSArray *)activities;

@property (strong, nonatomic) NSDictionary *datasource;

@end
