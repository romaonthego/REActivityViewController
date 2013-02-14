//
// REVKActivityViewController.h
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

#import "REVKActivityViewController.h"
#import "REAuthCell.h"

@interface REVKActivityViewController ()

@end

@implementation REVKActivityViewController

- (id)initWithClientId:(NSString *)clientId
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = NSLocalizedStringFromTable(@"activity.VKontakte.authentication.title", @"REActivityViewController", @"VKontakte");
        self.clientId = clientId;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"button.cancel", @"REActivityViewController", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=%@&scope=wall,photos&redirect_uri=http://oauth.vk.com/blank.html&display=touch&response_type=token", _clientId]]];
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
        [_webView loadRequest:request];
        
        [self.view addSubview:_webView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = CGPointMake(22, 22);
        [_indicatorView startAnimating];
       
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [view addSubview:_indicatorView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange searchRange = NSMakeRange(0, url.length);
    NSRange foundRange = [url rangeOfString:@"access_token" options:0 range:searchRange];
    if (foundRange.location != NSNotFound) {
        NSArray *items = [url componentsSeparatedByString:@"="];
        items = [[items objectAtIndex:1] componentsSeparatedByString:@"&"];
        NSString *token = [items objectAtIndex:0];
        
        NSArray *userAr = [url componentsSeparatedByString:@"&user_id="];
        NSString *userId = [userAr lastObject];
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"REVKActivity_Token"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"REVKActivity_UserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:^{
            [_activity share];
        }];
        
        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _indicatorView.hidden = YES;
}

#pragma mark -
#pragma mark Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    return (orientation == UIInterfaceOrientationPortrait);
}

@end
