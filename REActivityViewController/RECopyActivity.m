//
//  RECopyActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RECopyActivity.h"
#import "REActivityViewController.h"

@implementation RECopyActivity

- (id)init
{
    self = [super initWithTitle:@"Copy"
                          image:[UIImage imageNamed:@"Icon_Copy"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        NSDictionary *userInfo = activityViewController.userInfo;
                        
                        NSString *text = [userInfo objectForKey:@"text"];
                        UIImage *image = [userInfo objectForKey:@"image"];
                        NSURL *url = [userInfo objectForKey:@"url"];
                        if (text)
                            [UIPasteboard generalPasteboard].string = text;
                        if (url)
                            [UIPasteboard generalPasteboard].URL = url;
                        if (image) {
                            NSData *imageData = UIImageJPEGRepresentation(image, 0.75f);
                            [[UIPasteboard generalPasteboard] setData:imageData
                                                    forPasteboardType:[UIPasteboardTypeListImage objectAtIndex:0]];
                        }
                    }];
    
    return self;
}

@end
