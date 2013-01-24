//
//  RootViewController.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "REActivityViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 20, 280, 44);
    [button setTitle:@"Show REActivityViewController" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonPressed
{
    // Prepare activities
    //
    REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
    RETwitterActivity *twitterActivity = [[RETwitterActivity alloc] init];
    REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
    REMailActivity *mailActivity = [[REMailActivity alloc] init];
    
    // Add some custom activity
    //
    REActivity *customActivity = [[REActivity alloc] initWithTitle:@"Custom"
                                                             image:[UIImage imageNamed:@"CustomActivity"]
                                                       actionBlock:^(REActivityViewController *activityViewController){
                                                           [activityViewController dismissViewControllerAnimated:YES completion:nil];
                                                           NSLog(@"Hey, I'm pressed!");
                                                       }];
    
    // Compile activities into an array, we will pass that array to
    // REActivityViewController on the next step
    //
    NSArray *activities = @[facebookActivity, twitterActivity, messageActivity, mailActivity, customActivity];
    
    //self.presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    // Create REActivityViewController controller and assign data source
    //
    REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithActivities:activities];
    activityViewController.datasource = @{
        @"image": @"Test.jpg",
        @"text": @"Hello world!",
        @"url": @"https://github.com/romaonthego/REActivityViewController"
    };
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:activityViewController animated:YES completion:^{
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }];
}

@end
