//
//  REActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivity.h"

@implementation REActivity

- (id)initWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(REActivityActionBlock)actionBlock
{
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _actionBlock = [actionBlock copy];
    }
    return self;
}

@end
