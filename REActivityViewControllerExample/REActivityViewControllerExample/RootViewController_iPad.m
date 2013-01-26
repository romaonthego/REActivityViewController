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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed
{
    if (_activityPopoverController && _activityPopoverController.isPopoverVisible) {
        [_activityPopoverController dismissPopoverAnimated:YES];
        _activityPopoverController =  nil;
        return;
    }
    
    REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
    RETwitterActivity *twitterActivity = [[RETwitterActivity alloc] init];
    REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
    
   /* REMailActivity *mailActivity1 = [[REMailActivity alloc] init];
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
    
    NSArray *activities = @[facebookActivity, twitterActivity, messageActivity];
    
    //self.presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    // Create REActivityViewController controller and assign data source
    //
    REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];
    activityViewController.userInfo = @{
    @"image": [UIImage imageNamed:@"Temp@2x.png"],
    @"text": @"Hello world!",
    @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"]
    };
    
    _activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
    activityViewController.presentingPopoverController = _activityPopoverController;
    [_activityPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                       permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
