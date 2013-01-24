//
//  REActivityViewController.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivityViewController.h"

@interface REActivityViewController ()

@end

@implementation REActivityViewController

- (id)initWithActivities:(NSArray *)activities
{
    self = [super init];
    if (self) {
        self.view.opaque = NO;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 417, self.view.frame.size.width, 417)];
    _backgroundImageView.image = [UIImage imageNamed:@"Background"];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_backgroundImageView];
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
