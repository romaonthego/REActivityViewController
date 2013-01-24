//
//  REActivityView.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivityView.h"

@implementation REActivityView

- (id)initWithFrame:(CGRect)frame activities:(NSArray *)activities
{
    self = [super initWithFrame:frame];
    if (self) {
        _activities = activities;
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 417, frame.size.width, 417)];
        _backgroundImageView.image = [UIImage imageNamed:@"Background"];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backgroundImageView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39, frame.size.width, 417)];
        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
        
        NSInteger index = 0;
        NSInteger row = -1;
        NSInteger page = -1;
        for (REActivity *activity in _activities) {
            NSInteger col = index%3;
            if (index % 3 == 0) row++;
            if (index % 9 == 0) {
                row = 0;
                page++;
            }
            NSLog(@"index = %i", index % 9);
            UIView *view = [self viewForActivity:activity
                                           index:index
                                               x:(30 + col*80 + col*10) + page * frame.size.width
                                               y:row*80 + row*10];
            [_scrollView addSubview:view];
            index++;
        }
        _scrollView.contentSize = CGSizeMake((page +1) * frame.size.width, _scrollView.frame.size.height);
        _scrollView.pagingEnabled = YES;
        //[self addActivity:activity];
    }
    return self;
}

- (UIView *)viewForActivity:(REActivity *)activity index:(NSInteger)index x:(NSInteger)x y:(NSInteger)y
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, 80, 80)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 59, 59);
    button.tag = index;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:activity.image forState:UIControlStateNormal];
    [view addSubview:button];
    
    return view;
}

#pragma mark -
#pragma mark Button action

- (void)buttonPressed:(UIButton *)button
{
    REActivity *activity = [_activities objectAtIndex:button.tag];
    if (activity.actionBlock) {
        activity.actionBlock(_activityViewController);
    }
}

@end
