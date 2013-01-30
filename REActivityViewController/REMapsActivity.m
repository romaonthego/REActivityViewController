//
//  REMapsActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REMapsActivity.h"
#import "REActivityViewController.h"

@implementation REMapsActivity

- (id)init
{
    return [super initWithTitle:@"Open in Maps"
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Maps"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSString *url;
                        
                        if ([userInfo objectForKey:@"coordinate"]) {
                            url = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@,%@", [[userInfo objectForKey:@"coordinate"] objectForKey:@"latitude"], [[userInfo objectForKey:@"coordinate"] objectForKey:@"longitude"]];
                        } else {
                             url = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", [userInfo objectForKey:@"text"]];
                        }
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }];
}

@end
