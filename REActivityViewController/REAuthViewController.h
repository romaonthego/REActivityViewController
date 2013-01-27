//
//  REAuthViewController.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/27/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REAuthViewController : UITableViewController {
    UIActivityIndicatorView *_indicatorView;
}

@property (strong, nonatomic) NSArray *labels;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) void (^onLoginButtonPressed)(REAuthViewController *controller, NSString *username, NSString *password);

- (void)showLoginButton;
- (void)showActivityIndicator;

@end
