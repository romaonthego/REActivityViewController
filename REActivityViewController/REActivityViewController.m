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

- (NSInteger)height;

@end

@implementation REActivityViewController

- (id)initWithViewController:(UIViewController *)viewController activities:(NSArray *)activities
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, 320, 417);
        self.presentingController = viewController;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _backgroundView.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 0;
            [self.view addSubview:_backgroundView];
        }
        
        _activities = activities;
        _activityView = [[REActivityView alloc] initWithFrame:CGRectMake(0,
                                                                         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ?
                                                                         [UIScreen mainScreen].bounds.size.height : 0,
                                                                         self.view.frame.size.width, self.height)
                                                   activities:activities];
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _activityView.activityViewController = self;
        [self.view addSubview:_activityView];
        
        self.contentSizeForViewInPopover = CGSizeMake(320, self.height - 60);
    }
    return self;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.4 animations:^{
            _backgroundView.alpha = 0;
            CGRect frame = _activityView.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            _activityView.frame = frame;
        } completion:^(BOOL finished) {
            [super dismissViewControllerAnimated:NO completion:completion];
        }];
    } else {
        [self.presentingPopoverController dismissPopoverAnimated:YES];
        [self performBlock:^{
            if (completion)
                completion();
        } afterDelay:0.4];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.4 animations:^{
            _backgroundView.alpha = 0.4;
            
            CGRect frame = _activityView.frame;
            frame.origin.y = self.view.frame.size.height - self.height;
            _activityView.frame = frame;
        }];
    }
    
     [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}

- (NSInteger)height
{   
    if (_activities.count <= 3) return 214;
    if (_activities.count <= 6) return 317;
    return 417;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - 
#pragma mark Helpers

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(runBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)runBlockAfterDelay:(void (^)(void))block
{
	if (block != nil)
		block();
}

@end
