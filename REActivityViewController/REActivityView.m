//
// REActivityView.h
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

#import "REActivityView.h"
#import "REActivityViewController.h"

#ifdef __IPHONE_6_0 // iOS6 and later
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#   define UITextAlignmentLeft      NSTextAlignmentLeft
#   define UITextAlignmentRight     NSTextAlignmentRight
#   define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#   define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#endif

@implementation REActivityView

- (id)initWithFrame:(CGRect)frame activities:(NSArray *)activities
{    
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _activities = activities;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, (IS_IPHONE_5)? 517 :417)];
            _backgroundImageView.image = [UIImage imageNamed:@"REActivityViewController.bundle/Background"];
            _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self addSubview:_backgroundImageView];
        }
    
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 39, frame.size.width, self.frame.size.height - 104)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        NSInteger index = 0;
        NSInteger row = -1;
        NSInteger page = -1;
        for (REActivity *activity in _activities) {
            NSInteger col;
            
            col = index%3;
            if (index % 3 == 0) row++;
            if (IS_IPHONE_5) {
                if (index % 12 == 0) {
                    row = 0;
                    page++;
                }
            } else {
                if (index % 9 == 0) {
                    row = 0;
                    page++;
                }
            }

            UIView *view = [self viewForActivity:activity
                                           index:index
                                               x:(20 + col*80 + col*20) + page * frame.size.width
                                               y:row*80 + row*20];
            [_scrollView addSubview:view];
            index++;
        }
        _scrollView.contentSize = CGSizeMake((page +1) * frame.size.width, _scrollView.frame.size.height);
        _scrollView.pagingEnabled = YES;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 84, frame.size.width, 10)];
        _pageControl.numberOfPages = page + 1;
        [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        if (_pageControl.numberOfPages <= 1) {
            _pageControl.hidden = YES;
            _scrollView.scrollEnabled = NO;
        }
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[[UIImage imageNamed:@"REActivityViewController.bundle/Button"] stretchableImageWithLeftCapWidth:22 topCapHeight:47] forState:UIControlStateNormal];
        _cancelButton.frame = CGRectMake(22, 352, 276, 47);
        [_cancelButton setTitle:NSLocalizedStringFromTable(@"button.cancel", @"REActivityViewController", @"Cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitleShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [_cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (UIView *)viewForActivity:(REActivity *)activity index:(NSInteger)index x:(NSInteger)x y:(NSInteger)y
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, 80, 80)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 59, 59);
    button.tag = index;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:activity.image forState:UIControlStateNormal];
    button.accessibilityLabel = activity.title;
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, 80, 30)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = activity.title;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.numberOfLines = 0;
    [label setNumberOfLines:0];
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.x = roundf((view.frame.size.width - frame.size.width) / 2.0f);
    label.frame = frame;
    [view addSubview:label];
    
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // For iPhone and iPod
        CGRect scrollViewFrame = _scrollView.frame;
        CGRect cancelButtonFrame = _cancelButton.frame;
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            scrollViewFrame.origin.y = 39;
            
            cancelButtonFrame.size.width = 276;
            cancelButtonFrame.origin.y = self.frame.size.height - 47 - 16;
            cancelButtonFrame.origin.x = (self.frame.size.width - cancelButtonFrame.size.width) / 2.0f;
        } else {
            scrollViewFrame.origin.y = 29;
            
            cancelButtonFrame.size.width = 236;
            cancelButtonFrame.origin.y = self.frame.size.height - 47 - 18;
            cancelButtonFrame.origin.x = (self.frame.size.width - cancelButtonFrame.size.width) / 2.0f;
        }
        
        _scrollView.frame = scrollViewFrame;
        _cancelButton.frame = cancelButtonFrame;
        
        NSInteger index = 0;
        NSInteger row = -1;
        NSInteger page = -1;
        for (UIView *view in [_scrollView subviews]) {
            NSInteger col;
            CGRect frame = view.frame;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
                col = index%3;
                if (index % 3 == 0) row++;
                if (IS_IPHONE_5) {
                    if (index % 12 == 0) {
                        row = 0;
                        page++;
                    }
                } else {
                    if (index % 9 == 0) {
                        row = 0;
                        page++;
                    }
                }
                
                frame.origin.x = (20 + col*80 + col*20) + page * self.frame.size.width;
                
            } else {
                col = index%4;
                if (index % 4 == 0) row++;
                if (index % 8 == 0) {
                    row = 0;
                    page++;
                }
                
                if (IS_IPHONE_5) {
                    frame.origin.x = (48 + col*80 + col*50) + page * self.frame.size.width;
                } else {
                    frame.origin.x = (20 + col*80 + col*40) + page * self.frame.size.width;
                }
            }
            
            frame.origin.y = row*80 + row*20;
            view.frame = frame;
            
            index++;
        }
        
        _scrollView.contentSize = CGSizeMake((page +1) * self.frame.size.width, _scrollView.frame.size.height);
        _scrollView.pagingEnabled = YES;
        
        CGRect pageControlFrame = _pageControl.frame;
        pageControlFrame.origin.y = self.frame.size.height - 84;
        pageControlFrame.size.width = self.frame.size.width;
        _pageControl.frame = pageControlFrame;
        _pageControl.numberOfPages = page + 1;
        
        if (_pageControl.numberOfPages <= 1) {
            _pageControl.hidden = YES;
            _scrollView.scrollEnabled = NO;
        } else {
            _pageControl.hidden = NO;
            _scrollView.scrollEnabled = YES;
        }
        
        [self pageControlValueChanged:_pageControl];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // For iPad
        CGRect frame = _cancelButton.frame;
        frame.origin.y = self.frame.size.height - 47 - 16;
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2.0f;
        _cancelButton.frame = frame;
    }
}

#pragma mark -
#pragma mark Button action

- (void)cancelButtonPressed
{
    [_activityViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonPressed:(UIButton *)button
{
    REActivity *activity = [_activities objectAtIndex:button.tag];
    activity.activityViewController = _activityViewController;
    if (activity.actionBlock) {
        activity.actionBlock(activity, _activityViewController);
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark -

- (void)pageControlValueChanged:(UIPageControl *)pageControl
{
    CGFloat pageWidth = _scrollView.contentSize.width /_pageControl.numberOfPages;
    CGFloat x = _pageControl.currentPage * pageWidth;
    [_scrollView scrollRectToVisible:CGRectMake(x, 0, pageWidth, _scrollView.frame.size.height) animated:YES];
}

@end
