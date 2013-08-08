//
// RESinaWeiboActivity.m
// REActivityViewController
//
// Copyright (c) 2013 Jason Hao (https://github.com/hjue )
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

#import "RESinaWeiboActivity.h"
#import "REActivityViewController.h"

@implementation RESinaWeiboActivity

- (id)init
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.SinaWeibo.title", @"REActivityViewController", @"Sina Weibo")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Weibo"]
                    actionBlock:nil];
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        UIViewController *presenter = activityViewController.presentingController;
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            [weakSelf shareFromViewController:presenter
                                     text:[userInfo objectForKey:@"text"]
                                      url:[userInfo objectForKey:@"url"]
                                    image:[userInfo objectForKey:@"image"]];
        }];
    };
    
    return self;
}

- (void)shareFromViewController:(UIViewController *)viewController text:(NSString *)text url:(NSURL *)url image:(UIImage *)image
{
        SLComposeViewController *sinaWeiboViewComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        if (!sinaWeiboViewComposer) {
            return;
        }
        
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        if (text)
            [sinaWeiboViewComposer setInitialText:text];
        if (image)
            [sinaWeiboViewComposer addImage:image];
        if (url)
            [sinaWeiboViewComposer addURL:url];
        
        [viewController presentViewController:sinaWeiboViewComposer animated:YES completion:nil];
}

@end
