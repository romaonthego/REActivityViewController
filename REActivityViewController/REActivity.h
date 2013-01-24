//
//  REActivity.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REActivityViewController;

typedef void (^REActivityActionBlock)(REActivityViewController *activityViewController);

@interface REActivity : NSObject

@property (strong, readonly, nonatomic) NSString *title;
@property (strong, readonly, nonatomic) UIImage *image;
@property (copy, readonly, nonatomic) REActivityActionBlock actionBlock;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(REActivityActionBlock)actionBlock;

@end
