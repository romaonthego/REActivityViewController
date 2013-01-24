//
//  REActivityViewController.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivityViewController.h"
#import "REActivityView.h"

@interface REActivityViewController ()

@end

@implementation REActivityViewController

- (id)initWithActivities:(NSArray *)activities
{
    self = [super init];
    if (self) {
        _activities = activities;
        _activityView = [[REActivityView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 417) activities:activities];
        _activityView.activityViewController = self;
        [self.view addSubview:_activityView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _activityView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - self.height;
        _activityView.frame = frame;
    }];
}

- (NSInteger)height
{
    return 417;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
