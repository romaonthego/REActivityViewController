

#import <UIKit/UIKit.h>
#import "REVKActivity.h"

@interface REVKActivityViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *_webView;
    UIActivityIndicatorView *_indicatorView;
}

@property (copy, nonatomic) NSString *clientId;
@property (strong, nonatomic) REVKActivity *activity;

- (id)initWithClientId:(NSString *)clientId;

@end
