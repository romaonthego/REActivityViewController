//
//  REActivityView.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivityView.h"

@implementation REActivityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 417, frame.size.width, 417)];
        _backgroundImageView.image = [UIImage imageNamed:@"Background"];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backgroundImageView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39, frame.size.width, 417)];
        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
        
        [self addActivity:nil];
    }
    return self;
}

- (void)addActivity:(REActivity *)activity
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 0, 59, 59);
    [button setBackgroundImage:[UIImage imageNamed:@"Icon_Mail"] forState:UIControlStateNormal];
    [_scrollView addSubview:button];
}

@end
