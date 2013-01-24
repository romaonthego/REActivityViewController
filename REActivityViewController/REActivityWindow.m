//
//  REActivityWindow.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivityWindow.h"

@implementation REActivityWindow

static REActivityWindow *_sharedWindow = nil;

+ (REActivityWindow *)sharedWindow
{
    if (_sharedWindow != nil) {
        return _sharedWindow;
    }
    
    @synchronized(self) {
        if (_sharedWindow == nil) {
            _sharedWindow = [[self alloc] init];
        }
    }
    
    return _sharedWindow;
}

+ (id)allocWithZone:(NSZone*)zone
{
    @synchronized(self) {
        if (_sharedWindow == nil) {
            _sharedWindow = [super allocWithZone:zone];
            return _sharedWindow;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar;
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addToMainWindow:(UIView *)view
{
    if (self.hidden) {
        _previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
        self.alpha = 0.0f;
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        [self makeKeyWindow];
    }
    
    if (self.subviews.count > 0) {
        ((UIView *)[self.subviews lastObject]).userInteractionEnabled = NO;
    }
    
    [self addSubview:view];
}

- (void)reduceAlphaIfEmpty
{
    if (self.subviews.count == 1 || (self.subviews.count == 2 && [[self.subviews objectAtIndex:0] isKindOfClass:[UIImageView class]]))
    {
        self.alpha = 0.0f;
        self.userInteractionEnabled = NO;
    }
}

- (void)removeAll
{
    for (UIView *view in self.subviews) {
        [self removeView:view];
    }
}

- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
    
    UIView *topView = [self.subviews lastObject];
    if ([topView isKindOfClass:[UIImageView class]])
    {
        // It's a background. Remove it too
        [topView removeFromSuperview];
    }
    
    if (self.subviews.count == 0)
    {
        self.hidden = YES;
        [_previousKeyWindow makeKeyWindow];
        _previousKeyWindow = nil;
    }
    else
    {
        ((UIView*)[self.subviews lastObject]).userInteractionEnabled = YES;
    }
}

@end
