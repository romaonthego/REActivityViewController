//
// REMailActivity.m
// REActivityViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REMailActivity.h"
#import "REActivityViewController.h"
#import "REActivityDelegateObject.h"

@implementation REMailActivity

- (id)init
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Mail.title", @"REActivityViewController", @"Mail")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Mail"]
                    actionBlock:nil];
    
    
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        NSString *subject = [userInfo objectForKey:@"subject"];
        NSString *text = [userInfo objectForKey:@"text"];
        id attachment = [userInfo objectForKey:@"attachment"];
        NSURL *url = [userInfo objectForKey:@"url"];
        
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
			if (mailComposeViewController) {
				[REActivityDelegateObject sharedObject].controller = activityViewController.presentingController;
				mailComposeViewController.mailComposeDelegate = [REActivityDelegateObject sharedObject];
				
				if (text && !url)
					[mailComposeViewController setMessageBody:text isHTML:YES];
				
				if (!text && url)
					[mailComposeViewController setMessageBody:url.absoluteString isHTML:YES];
				
				if (text && url)
					[mailComposeViewController setMessageBody:[NSString stringWithFormat:@"%@ %@", text, url.absoluteString] isHTML:YES];
				
				if (attachment) {
                    if ([attachment isKindOfClass:[NSString class]] || [attachment isKindOfClass:[NSURL class]]) {
                        NSURL *attachmentURL = nil;
                        if ([attachment isKindOfClass:[NSString class]]) {
                            attachmentURL = [NSURL URLWithString:attachment];
                        } else {
                            attachmentURL = attachment;
                        }
                        
                        NSURLRequest *attachmentURLRequest = [NSURLRequest requestWithURL:attachmentURL];
                        NSError *error = nil;
                        NSURLResponse *response = nil;
                        
                        NSData *attachmentData = [NSURLConnection sendSynchronousRequest:attachmentURLRequest
                                                                       returningResponse:&response
                                                                                   error:&error];
                        if (!error) {
                            NSString *attachmentMimeType = [response MIMEType];
                            NSString *attachmentFileName = [attachmentURL lastPathComponent];
                            
                            [mailComposeViewController addAttachmentData:attachmentData mimeType:attachmentMimeType fileName:attachmentFileName];
                        } else {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Mail.error.title", @"REActivityViewController", @"Error.")
                                                                                message:NSLocalizedStringFromTable(@"activity.Mail.error.message", @"REActivityViewController", error)
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil, nil];
                            
                            [alertView show];
                        }
                    } else if ([attachment isKindOfClass:[UIImage class]]) {
                        [mailComposeViewController addAttachmentData:UIImageJPEGRepresentation(attachment, 0.75f) mimeType:@"image/jpeg" fileName:@"image.jpg"];
                    }
                }
				
				if (subject)
					[mailComposeViewController setSubject:subject];
				
				[activityViewController.presentingController presentViewController:mailComposeViewController animated:YES completion:nil];
			}
        }];
    };
    
    return self;
}

@end
