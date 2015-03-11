//
// REMessageActivity.m
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

#import "REMessageActivity.h"
#import "REActivityViewController.h"
#import "REActivityDelegateObject.h"

@implementation REMessageActivity

- (id)init
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Message.title", @"REActivityViewController", @"Message")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Message"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        NSString *text = [userInfo objectForKey:@"text"];
        NSURL *url = [userInfo objectForKey:@"url"];
		id attachment = [userInfo objectForKey:@"image"];
		
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            if (![MFMessageComposeViewController canSendText])
                return;
            
            MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
            [REActivityDelegateObject sharedObject].controller = activityViewController.presentingController;
            messageComposeViewController.messageComposeDelegate = [REActivityDelegateObject sharedObject];
            
            if (text && !url)
                messageComposeViewController.body = text;
            
            if (!text && url)
                messageComposeViewController.body = url.absoluteString;
            
            if (text && url)
                messageComposeViewController.body = [NSString stringWithFormat:@"%@ %@", text, url.absoluteString];

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
						NSString *attachmentFileName = [attachmentURL lastPathComponent];
						
						[messageComposeViewController addAttachmentData:attachmentData typeIdentifier:@"public.data" filename:attachmentFileName];
					} else {
						UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Message.error.title", @"REActivityViewController", @"Error.")
																			message:NSLocalizedStringFromTable(@"activity.Mail.error.message", @"REActivityViewController", error)
																		   delegate:nil
																  cancelButtonTitle:@"OK"
																  otherButtonTitles:nil, nil];
						
						[alertView show];
					}
				} else if ([attachment isKindOfClass:[UIImage class]]) {
					[messageComposeViewController addAttachmentData:UIImagePNGRepresentation(attachment) typeIdentifier:@"public.data" filename:@"image.png"];
				}
			}
			
			[REActivityDelegateObject sharedObject].sharingCompletion = activityViewController.completionHandler;
			[REActivityDelegateObject sharedObject].activityType = activity.activityType;

            [activityViewController.presentingController presentViewController:messageComposeViewController animated:YES completion:nil];
        }];
    };
    
    return self;
}

-(NSString *)activityType
{
    return UIActivityTypeMessage;
}

@end
