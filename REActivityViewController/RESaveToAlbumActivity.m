//
//  RESaveToAlbumActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RESaveToAlbumActivity.h"
#import "REActivityViewController.h"

@implementation RESaveToAlbumActivity

- (id)init
{
    self = [super initWithTitle:@"Save to Album"
                          image:[UIImage imageNamed:@"Icon_Photos"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSLog(@"Save = %@", userInfo);
                    }];
    
    return self;
}

@end
