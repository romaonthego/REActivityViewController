//
// REActivityViewController.m
// REActivityViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REActivityViewController.h"
#import "REActivityView.h"

@interface REActivityViewController ()

@property (strong, readonly, nonatomic) UIView *backgroundView;

- (NSInteger)height;

@end

@implementation REActivityViewController

- (void)loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        self.view = [[UIView alloc] initWithFrame:rootViewController.view.bounds];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        [super loadView];
    }
}

- (id)initWithViewController:(UIViewController *)viewController activities:(NSArray *)activities
{
    self = [super init];
    if (self) {
        self.presentingController = viewController;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _backgroundView.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 0;
            [self.view addSubview:_backgroundView];
        } else {
            self.view.frame = CGRectMake(0, 0, 320, 417);
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
        __typeof (&*self) __weak weakSelf = self;
        [UIView animateWithDuration:0.4 animations:^{
            _backgroundView.alpha = 0;
            CGRect frame = _activityView.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            _activityView.frame = frame;
        } completion:^(BOOL finished) {
            [weakSelf.view removeFromSuperview];
            [weakSelf removeFromParentViewController];
            if (completion)
                completion();
        }];
    } else {
        [self.presentingPopoverController dismissPopoverAnimated:YES];
        [self performBlock:^{
            if (completion)
                completion();
        } afterDelay:0.4];
    }
}

- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    self.rootViewController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    _backgroundView.frame = self.rootViewController.view.bounds;
    
    __typeof (&*self) __weak weakSelf = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.backgroundView.alpha = 0.4;
            
            CGRect frame = weakSelf.activityView.frame;
            
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                frame.origin.y = weakSelf.rootViewController.view.frame.size.height - self.height;
            } else {
                if (_activities.count <= 4) {
                    frame.origin.y = weakSelf.rootViewController.view.frame.size.width - self.height;
                } else {
                    frame.origin.y = [parent isKindOfClass:[UINavigationController class]] ? 20 : -10;
                }
            }
            
            weakSelf.activityView.frame = frame;
            
        }];
    }
}

- (NSInteger)height
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (_activities.count <= 3) return 214;
        if (_activities.count <= 6) return 317;
        if (IS_IPHONE_5 && _activities.count > 9) {
            return 517;
        }
        return 417;
    } else {
        if (_activities.count <= 4) return 214;
        return 310;
    }
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        __typeof (&*self) __weak weakSelf = self;
        CGRect frame = weakSelf.activityView.frame;
    
        if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
            frame.origin.y = weakSelf.rootViewController.view.frame.size.height - self.height;
        } else {
            if (_activities.count <= 4) {
                frame.origin.y = weakSelf.rootViewController.view.frame.size.width - self.height;
            } else {
                frame.origin.y = [weakSelf.rootViewController isKindOfClass:[UINavigationController class]] ? 20 : -10;
            }
        }
    
        frame.size.height = self.height;
        weakSelf.activityView.frame = frame;
    }
}

@end
