//
//  RootViewController_iPad.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController_iPad.h"
#import "REActivityViewController.h"

@implementation RootViewController_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonPressed)];
	self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)buttonPressed
{    
    if (_activityPopoverController && _activityPopoverController.isPopoverVisible) {
        [_activityPopoverController dismissPopoverAnimated:YES];
        _activityPopoverController =  nil;
        return;
    }
    
    // Prepare activities
    //
    REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
    RETwitterActivity *twitterActivity = [[RETwitterActivity alloc] init];
    REVKActivity *vkActivity = [[REVKActivity alloc] initWithClientId:@"3396235"];
    RETumblrActivity *tumblrActivity = [[RETumblrActivity alloc] initWithConsumerKey:@"CONSUMER KEY" consumerSecret:@"CONSUMER SECRET"];
    REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
    REMailActivity *mailActivity = [[REMailActivity alloc] init];
    RESafariActivity *safariActivity = [[RESafariActivity alloc] init];
    REChromeActivity *chromeActivity = [[REChromeActivity alloc] init];
    REPocketActivity *pocketActivity = [[REPocketActivity alloc] initWithConsumerKey:@"11708-5a8fa563a3485a5133ef1b56"];
    REInstapaperActivity *instapaperActivity = [[REInstapaperActivity alloc] init];
    REReadabilityActivity *readabilityActivity = [[REReadabilityActivity alloc] initWithConsumerKey:@"CONSUMER KEY" consumerSecret:@"CONSUMER SECRET"];
    REDiigoActivity *diigoActivity = [[REDiigoActivity alloc] initWithAPIKey:@"ed3f4751e5fe5271"];
    REKipptActivity *kipptActivity = [[REKipptActivity alloc] init];
    RESaveToCameraRollActivity *saveToCameraRollActivity = [[RESaveToCameraRollActivity alloc] init];
    REMapsActivity *mapsActivity = [[REMapsActivity alloc] init];
    REPrintActivity *printActivity = [[REPrintActivity alloc] init];
    RECopyActivity *copyActivity = [[RECopyActivity alloc] init];
    
    // Create some custom activity
    //
    REActivity *customActivity = [[REActivity alloc] initWithTitle:@"Custom"
                                                             image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Custom"]
                                                       actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                           [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                               NSLog(@"Info: %@", activityViewController.userInfo);
                                                           }];
                                                       }];
    
    // Compile activities into an array, we will pass that array to
    // REActivityViewController on the next step
    //
    NSArray *activities = @[facebookActivity, twitterActivity, vkActivity, tumblrActivity,
                            messageActivity, mailActivity, safariActivity, chromeActivity, pocketActivity,
                            instapaperActivity, readabilityActivity, diigoActivity, kipptActivity,
                            saveToCameraRollActivity, mapsActivity, printActivity,
                            copyActivity, customActivity];
    
    // Create REActivityViewController controller and assign data source
    //
    REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];
    activityViewController.userInfo = @{
                                        @"image": [UIImage imageNamed:@"Flower.jpg"],
                                        @"text": @"Hello world!",
                                        @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"],
                                        @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
                                        };
    
    // Present it from UIPopoverController
    //
    _activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
    activityViewController.presentingPopoverController = _activityPopoverController;
    [_activityPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                       permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark -
#pragma mark Orientation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
