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
    imageView.image = [UIImage imageNamed:@"Temp2"];
    //[self.view addSubview:imageView];
	
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 20, 280, 44);
    [button setTitle:@"Show REActivityViewController" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(20, 70, 280, 44);
    [button2 setTitle:@"Show UIActivityViewController" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)button2Pressed
{
    NSArray *activityItems = @[@"Test", [NSURL URLWithString:@"http://google.com"], [UIImage imageNamed:@"Flower.jpg"]];
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
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
    REMailActivity *mailActivity = [[REMailActivity alloc] init];
    RESafariActivity *safariActivity = [[RESafariActivity alloc] init];
    RESaveToAlbumActivity *saveToAlbumActivity = [[RESaveToAlbumActivity alloc] init];
    REPrintActivity *printActivity = [[REPrintActivity alloc] init];
    RECopyActivity *copyActivity = [[RECopyActivity alloc] init];
    REMapsActivity *mapsActivity = [[REMapsActivity alloc] init];
    
    /*
     Save to Album
     Pocket
     Instapaper
     VKontakte
     */
    
    /*REMailActivity *mailActivity1 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity2 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity3 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity4 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity5 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity6 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity7 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity8 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity9 = [[REMailActivity alloc] init];
    REMailActivity *mailActivity10 = [[REMailActivity alloc] init];*/
    
    // Compile activities into an array, we will pass that array to
    // REActivityViewController on the next step
    //
    //NSArray *activities = @[facebookActivity, twitterActivity, messageActivity, mailActivity, customActivity];
    
    NSArray *activities = @[facebookActivity, twitterActivity, messageActivity, mailActivity, saveToAlbumActivity, safariActivity, mapsActivity, printActivity, copyActivity];
    
    //self.presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    // Create REActivityViewController controller and assign data source
    //
    REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];
    activityViewController.userInfo = @{
        @"image": [UIImage imageNamed:@"Flower.jpg"],
        @"text": @"Hello world!",
        @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"],
        @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
    };
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:activityViewController animated:YES completion:^{
        self.modalPresentationStyle = UIModalPresentationFullScreen;
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
