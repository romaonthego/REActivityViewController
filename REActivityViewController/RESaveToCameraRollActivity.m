//
//  RESaveToCameraRollActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RESaveToCameraRollActivity.h"
#import "REActivityViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation RESaveToCameraRollActivity

- (id)init
{
    return [super initWithTitle:@"Save to Camera Roll"
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Photos"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        NSDictionary *userInfo = activityViewController.userInfo;
                        UIImage *image = [userInfo objectForKey:@"image"];
                        
                        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                        [library writeImageToSavedPhotosAlbum:image.CGImage
                                                  orientation:(ALAssetOrientation)image.imageOrientation
                                              completionBlock:nil];
                    }];
}

@end
