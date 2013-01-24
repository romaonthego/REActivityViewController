//
//  REMailActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REMailActivity.h"

@implementation REMailActivity

- (id)init
{
    self = [super initWithTitle:@"Mail"
                          image:[UIImage imageNamed:@"Icon_Mail"]
                    actionBlock:^(REActivityViewController *activityViewController) {
        
    }];
    
    return self;
}

@end
