# REActivityViewController

Open source alternative to UIActivityViewController, highly customizable and compatible with iOS 5.0.
It allows to create custom activites with ease, you control their apperance and behavior and no longer restricted to single-color icons as with the default `UIActivity`.

![Screenshot of REActivityViewController](https://github.com/romaonthego/REActivityViewController/raw/master/Screenshot.png "REActivityViewController Screenshot")

All activites are compatible with iOS 5.0.

* Facebook
* Twitter
* VKontakte
* Tubmlr
* Message
* Mail
* Open in Safari
* Save to Pocket
* Save to Instapaper
* Save to Album
* Open in Maps
* Print
* Copy

## Requirements
* Xcode 4.5 or higher
* Apple LLVM compiler
* iOS 5.0 or higher
* ARC

If you are not using ARC in your project, add `-fobjc-arc` as a compiler flag for all the files in this project.

## Demo

Build and run the `REActivityViewControllerExample` project in Xcode to see `REActivityViewController` in action.

## Installation

The recommended approach for installating REActivityViewController is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Edit your Podfile and add REActivityViewController:

``` bash
$ edit Podfile
platform :ios, '5.0'
pod 'REActivityViewController', '~> 1.0'
```

Install into your Xcode project:

``` bash
$ pod install
```

Add `#include "REActivityViewController.h"` to the top of classes that will use it.

## Example Usage

### Configuring & presenting REActivityViewController

Presenting `REActivityViewController` is easy as 1-2-3. First, prepare activities that you're going to use.
You can create custom activities right here in your code, no need to wrap your head around subclassing or providers as with `UIActivityViewController`.
Once your activities are ready, prepare data source (userInfo) and present the view controller.

``` objective-c
// Prepare activities
//
REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
RETwitterActivity *twitterActivity = [[RETwitterActivity alloc] init];
REVKActivity *vkActivity = [[REVKActivity alloc] init];
RETumblrActivity *tumblrActivity = [[RETumblrActivity alloc] init];
REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
REMailActivity *mailActivity = [[REMailActivity alloc] init];
RESafariActivity *safariActivity = [[RESafariActivity alloc] init];
REPocketActivity *pocketActivity = [[REPocketActivity alloc] init];
REInstapaperActivity *instapaperActivity = [[REInstapaperActivity alloc] init];
RESaveToAlbumActivity *saveToAlbumActivity = [[RESaveToAlbumActivity alloc] init];
REMapsActivity *mapsActivity = [[REMapsActivity alloc] init];
REPrintActivity *printActivity = [[REPrintActivity alloc] init];
RECopyActivity *copyActivity = [[RECopyActivity alloc] init];

// Create some custom activity
//
REActivity *customActivity = [[REActivity alloc] initWithTitle:@"Custom"
                                                         image:[UIImage imageNamed:@"Icon_Custom"]
                                                   actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                       [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                           NSLog(@"Hey, there!");
                                                       }];
                                                   }];

// Compile activities into an array, we will pass that array to
// REActivityViewController on the next step
//
NSArray *activities = @[facebookActivity, twitterActivity, vkActivity, tumblrActivity,
messageActivity, mailActivity, safariActivity, pocketActivity, instapaperActivity,
saveToAlbumActivity, mapsActivity, printActivity, copyActivity, customActivity];

// Create REActivityViewController controller and assign data source
//
REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];
activityViewController.userInfo = @{
    @"image": [UIImage imageNamed:@"Flower.jpg"],
    @"text": @"Hello world!",
    @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"],
    @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
};

// Present it using current context
//
self.modalPresentationStyle = UIModalPresentationCurrentContext;
[self presentViewController:activityViewController animated:YES completion:^{
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}];
```

### iPad specific

On iPad, you should use `UIPopoverController` to present `REActivityViewController`.
`_popoverViewController` property of UIViewController is still a private API (sigh), so we'll need to pass it manually:
`activityViewController.presentingPopoverController = _activityPopoverController;`

``` objective-c
// Create REActivityViewController controller and assign data source
//
REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];
    @"image": [UIImage imageNamed:@"Flower.jpg"],
    @"text": @"Hello world!",
    @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"],
    @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
};

_activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
activityViewController.presentingPopoverController = _activityPopoverController;
[_activityPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
```

### Creating custom activities

Creating custom activitis is super easy, see yourself:

``` objective-c
REActivity *customActivity = [[REActivity alloc] initWithTitle:@"Custom"
                                                         image:[UIImage imageNamed:@"Icon_Custom"]
                                                   actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                       [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                           NSLog(@"Hey, there!");
                                                       }];
                                                   }];
```

If you want to subclass an activity, add this code into your `init` function, for example:

``` objective-c
#import "MyCustomActivity.h"
#import "REActivityViewController.h"

@implementation MyCustomActivity

- (id)init
{
    self = [super initWithTitle:@"My Activity"
                          image:[UIImage imageNamed:@"My_Icon"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        // Your code goes here
                    }];

    return self;
}

@end

```

## Customization

All views are exposed for your customization. Say, you want to change controller background and customize cancel button, here is how you would do it:

``` objective-c
REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];

activityViewController.activityView.backgroundImageView.image = [UIImage imageNamed:@"My_Cool_Background"];
[activityViewController.activityView.cancelButton setBackgroundImage:[UIImage imageNamed:@"My_Cool_Button"] forState:UIControlStateNormal];
```

## Known Issues

* REActivityViewController doesn't support landscape orientation on iPhone, so you'll need to lock your presenting view controller in portrait orientation.

## Contact

Roman Efimov

- https://github.com/romaonthego
- https://twitter.com/romaonthego

## License

REActivityViewController is available under the MIT license.

Copyright © 2013 Roman Efimov.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
