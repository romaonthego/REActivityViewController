//
//  REMessageActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REMessageActivity.h"
#import "REActivityViewController.h"
#import "REActivityDelegateObject.h"

@implementation REMessageActivity

- (id)init
{
    return [super initWithTitle:@"Message"
                          image:[UIImage imageNamed:@"Icon_Message"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSString *text = [userInfo objectForKey:@"text"];
                        NSURL *url = [userInfo objectForKey:@"url"];
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
                            [REActivityDelegateObject sharedObject].controller = activityViewController.presentingController;
                            messageComposeViewController.messageComposeDelegate = [REActivityDelegateObject sharedObject];
                            
                            if (text && !url)
                                messageComposeViewController.body = text;
                            
                            if (!text && url)
                                messageComposeViewController.body = url.absoluteString;
                            
                            if (text && url)
                                messageComposeViewController.body = [NSString stringWithFormat:@"%@ %@", text, url.absoluteString];
                            
                            [activityViewController.presentingController presentViewController:messageComposeViewController animated:YES completion:nil];
                        }];
                    }];
}

@end
