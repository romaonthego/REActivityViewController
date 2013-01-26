//
//  REActivityView.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REActivity.h"

@interface REActivityView : UIView <UIScrollViewDelegate> {
    UIPageControl *_pageControl;
}

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *activities;
@property (strong, nonatomic) REActivityViewController *activityViewController;
@property (strong, nonatomic) UIButton *cancelButton;

- (id)initWithFrame:(CGRect)frame activities:(NSArray *)activities;

@end
