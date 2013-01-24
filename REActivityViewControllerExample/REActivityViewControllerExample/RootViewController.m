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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)];
    imageView.image = [UIImage imageNamed:@"Temp"];
   // [self.view addSubview:imageView];
	
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
 /*   REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
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
  */
    
    REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
    RETwitterActivity *twitterActivity = [[RETwitterActivity alloc] init];
    REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
    
    REMailActivity *mailActivity1 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity2 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity3 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity4 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity5 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity6 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity7 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity8 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity9 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity10 = [[REMailActivity alloc] init];
    
    // Compile activities into an array, we will pass that array to
    // REActivityViewController on the next step
    //
    //NSArray *activities = @[facebookActivity, twitterActivity, messageActivity, mailActivity, customActivity];
    
    NSArray *activities = @[facebookActivity, twitterActivity, messageActivity, mailActivity1, mailActivity2, mailActivity3, mailActivity4, mailActivity5, mailActivity6, mailActivity7, mailActivity8, mailActivity9, mailActivity10];
    
    //self.presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    // Create REActivityViewController controller and assign data source
    //
    REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithActivities:activities];
    activityViewController.userInfo = @{
        @"image": [UIImage imageNamed:@"Temp@2x.png"],
        @"text": @"Hello world!",
        @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"]
    };
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:activityViewController animated:YES completion:^{
    //    self.modalPresentationStyle = UIModalPresentationFullScreen;
    }];
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

@end
