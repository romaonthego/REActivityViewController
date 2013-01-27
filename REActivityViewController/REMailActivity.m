//
//  REMailActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/24/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REMailActivity.h"
#import "REActivityViewController.h"
#import "REActivityDelegateObject.h"

@implementation REMailActivity

- (id)init
{
    return [super initWithTitle:@"Mail"
                          image:[UIImage imageNamed:@"Icon_Mail"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        NSDictionary *userInfo = activityViewController.userInfo;
                        NSString *text = [userInfo objectForKey:@"text"];
                        UIImage *image = [userInfo objectForKey:@"image"];
                        NSURL *url = [userInfo objectForKey:@"url"];
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
                            [REActivityDelegateObject sharedObject].controller = activityViewController.presentingController;
                            mailComposeViewController.mailComposeDelegate = [REActivityDelegateObject sharedObject];
                            
                            if (text && !url)
                                [mailComposeViewController setMessageBody:text isHTML:YES];
                            
                            if (!text && url)
                                [mailComposeViewController setMessageBody:url.absoluteString isHTML:YES];
                            
                            if (text && url)
                                [mailComposeViewController setMessageBody:[NSString stringWithFormat:@"%@ %@", text, url.absoluteString] isHTML:YES];
                            
                            if (image)
                                [mailComposeViewController addAttachmentData:UIImageJPEGRepresentation(image, 0.75f) mimeType:@"image/jpeg" fileName:@"photo.jpg"];
                            
                            [activityViewController.presentingController presentViewController:mailComposeViewController animated:YES completion:nil];
                        }];
    }];
}

@end
