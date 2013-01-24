//
//  REActivityWindow.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REActivityWindow : UIWindow {
@private
    UIWindow *_previousKeyWindow;
}

+ (REActivityWindow *)sharedWindow;

- (void)addToMainWindow:(UIView *)view;
- (void)reduceAlphaIfEmpty;
- (void)removeView:(UIView *)view;
- (void)removeAll;


@end
