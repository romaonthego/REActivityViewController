//
// REPrintActivity.m
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

#import "REPrintActivity.h"
#import "REActivityViewController.h"

@implementation REPrintActivity

- (id)init
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.Print.title", @"REActivityViewController", @"Print")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Print"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
            
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = [userInfo objectForKey:@"text"];
            pc.printInfo = printInfo;
            
            pc.printingItem = [userInfo objectForKey:@"image"];
            
            void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
            ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
                if (!completed && error) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"activity.Print.error.title", @"REActivityViewController", @"Error.")
                                                                 message:[NSString stringWithFormat:NSLocalizedStringFromTable(@"activity.Print.error.message", @"REActivityViewController", @"An error occured while printing: %@"), error]
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                    
                    [av show];
                }
            };
            
            [pc presentAnimated:YES completionHandler:completionHandler];
        }];
    };
    
    return self;
}

@end
