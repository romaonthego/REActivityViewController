//
//  REPocketActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REPocketActivity.h"
#import "REActivityViewController.h"
#import "PocketAPI.h"

@implementation REPocketActivity

- (id)initWithConsumerKey:(NSString *)consumerKey
{
    return [super initWithTitle:@"Save to Pocket"
                          image:[UIImage imageNamed:@"Icon_Pocket"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        [activityViewController dismissViewControllerAnimated:YES completion:nil];
                        NSDictionary *userInfo = activityViewController.userInfo;
                        [[PocketAPI sharedAPI] setConsumerKey:consumerKey];
                        if ([PocketAPI sharedAPI].username) {
                            [self saveURL:[userInfo objectForKey:@"url"]];
                        } else {
                            [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error) {
                                if (!error)
                                    [self saveURL:[userInfo objectForKey:@"url"]];
                            }];
                        }                        
                    }];
}

- (void)saveURL:(NSURL *)url
{
    if (!url) return;
    [[PocketAPI sharedAPI] saveURL:url handler:nil];
}

@end
