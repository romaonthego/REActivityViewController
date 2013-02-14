//
// REMapsActivity.m
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

#import "REMapsActivity.h"
#import "REActivityViewController.h"

@implementation REMapsActivity

- (id)init
{
    return [super initWithTitle:NSLocalizedStringFromTable(@"activity.Maps.title",@"REActivityViewController",@"Open in Maps")
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
