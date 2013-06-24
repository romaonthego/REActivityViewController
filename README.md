# REActivityViewController

Open source alternative to UIActivityViewController, highly customizable and compatible with iOS 5.0.
It allows to create custom activites with ease, you control their apperance and behavior and no longer restricted to single-color icons as with the default `UIActivity`.

<img src="https://github.com/romaonthego/REActivityViewController/raw/master/Screenshot.png" alt="REActivityViewController Screenshot" width="660" height="480" />

> Out of the box activities include:

> * Facebook
* Twitter
* VKontakte
* Tumblr (using XAuth)
* Message
* Mail
* Open in Safari
* Save to Pocket
* Send to Instapaper
* Save to Readability
* Save to Diigo
* Save to Kippt
* Save to Album
* Open in Maps
* Print
* Copy

> All activites are compatible with iOS 5.0.

## Requirements
* Xcode 4.5 or higher
* Apple LLVM compiler
* iOS 5.0 or higher
* ARC

## Demo

First, you need to install dependencies using [CocoaPods](http://cocoapods.org/) package manager in the demo project:

``` bash
$ pod install
```

After that, build and run the `REActivityViewControllerExample` project in Xcode to see `REActivityViewController` in action.

If you don't have CocoaPods installed, check section "Installation" below.

## Installation

The recommended approach for installating REActivityViewController is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Edit your Podfile and add `REActivityViewController`:

``` bash
$ edit Podfile
platform :ios, '5.0'
pod 'REActivityViewController', '~> 1.6.2'
```

Install into your Xcode project:

``` bash
$ pod install
```

Add `#include "REActivityViewController.h"` to the top of classes that will use it.

### Manual installation

`REActivityViewController` needs to be linked with the following frameworks:

* QuartzCore
* AssetsLibrary
* MessageUI
* Twitter

The following framework must be added as optional (weak reference):

* Social

Dependencies:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking) ~> 1.3.0
* [Facebook-iOS-SDK](https://github.com/facebook/facebook-ios-sdk) ~> 3.5.1
* [DEFacebookComposeViewController](https://github.com/sakrist/FacebookSample) ~> 1.0.0
* [REComposeViewController](https://github.com/romaonthego/REComposeViewController) ~> 2.1.1
* [SFHFKeychainUtils](https://github.com/ldandersen/scifihifi-iphone/tree/master/security) ~> 0.0.1
* [PocketAPI](https://github.com/Pocket/Pocket-ObjC-SDK) ~> 1.0.2
* [AFXAuthClient](https://github.com/romaonthego/AFXAuthClient) ~> 1.0.5

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
REVKActivity *vkActivity = [[REVKActivity alloc] initWithClientId:@"VK APP ID"];
RETumblrActivity *tumblrActivity = [[RETumblrActivity alloc] initWithConsumerKey:@"CONSUMER KEY" consumerSecret:@"CONSUMER SECRET"];
REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
REMailActivity *mailActivity = [[REMailActivity alloc] init];
RESafariActivity *safariActivity = [[RESafariActivity alloc] init];
REPocketActivity *pocketActivity = [[REPocketActivity alloc] initWithConsumerKey:@"CONSUMER KEY"];
REInstapaperActivity *instapaperActivity = [[REInstapaperActivity alloc] init];
REReadabilityActivity *readabilityActivity = [[REReadabilityActivity alloc] initWithConsumerKey:@"CONSUMER KEY" consumerSecret:@"CONSUMER SECRET"];
REDiigoActivity *diigoActivity = [[REDiigoActivity alloc] initWithAPIKey:@"API KEY"];
REKipptActivity *kipptActivity = [[REKipptActivity alloc] init];
RESaveToCameraRollActivity *saveToCameraRollActivity = [[RESaveToCameraRollActivity alloc] init];
REMapsActivity *mapsActivity = [[REMapsActivity alloc] init];
REPrintActivity *printActivity = [[REPrintActivity alloc] init];
RECopyActivity *copyActivity = [[RECopyActivity alloc] init];

// Create some custom activity
//
REActivity *customActivity = [[REActivity alloc] initWithTitle:@"Custom"
                                                         image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Custom"]
                                                   actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                                                       [activityViewController dismissViewControllerAnimated:YES completion:^{
                                                           NSLog(@"Info: %@", activityViewController.userInfo);
                                                       }];
                                                   }];

// Compile activities into an array, we will pass that array to
// REActivityViewController on the next step
//
NSArray *activities = @[facebookActivity, twitterActivity, vkActivity, tumblrActivity,
messageActivity, mailActivity, safariActivity, pocketActivity, instapaperActivity,
readabilityActivity, diigoActivity, kipptActivity, saveToCameraRollActivity, mapsActivity,
printActivity, copyActivity, customActivity];

// Create REActivityViewController controller and assign data source
//
REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self activities:activities];
activityViewController.userInfo = @{
    @"image": [UIImage imageNamed:@"Flower.jpg"],
    @"text": @"Hello world!",
    @"url": [NSURL URLWithString:@"https://github.com/romaonthego/REActivityViewController"],
    @"coordinate": @{@"latitude": @(37.751586275), @"longitude": @(-122.447721511)}
};

[activityViewController presentFromRootViewController];
```

You can also define per-activity userInfo dictionaries, for instance:

``` objective-c
twitterActivity.userInfo = @{@"image": [UIImage imageNamed:@"Flower.jpg"],
                             @"text": @"Hello world! via @myapp"};
```

### iPad specific

On iPad, you should use `UIPopoverController` to present `REActivityViewController`.
`_popoverController` property of `UIViewController` is still a private API (sigh), so we'll need to pass it manually:
`activityViewController.presentingPopoverController = _activityPopoverController;`

``` objective-c
// Create REActivityViewController controller and assign data source
//
REActivityViewController *activityViewController = [[REActivityViewController alloc] initWithViewController:self.navigationController activities:activities];
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

Please note that our presenting view controller is the navigation controller, so we pass it in `initWithViewController`.

### Creating custom activities

Creating custom activitis is super easy:

``` objective-c
REActivity *customActivity = [[REActivity alloc] initWithTitle:@"Custom"
                                                         image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Custom"]
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
    return [super initWithTitle:@"My Activity"
                          image:[UIImage imageNamed:@"My_Icon"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        // Your code goes here
                    }];
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

Your custom activity icons must be 118x118 pixels and should include gloss, rounded corners and shadows. Easy way to make them:

1. Open your 114x114 icon with rounded corners in Photoshop (you can convert your square icon using template from http://appicontemplate.com).
2. Adjust canvas size to be 118x118, so the top part of the icon touches top part of the canvas.
3. Add drop shadow to the icon layer: angle 90, opacity 40%, distance 2px, size 2px.

## Contact

Roman Efimov

- https://github.com/romaonthego
- https://twitter.com/romaonthego
- romefimov@gmail.com

## License

REActivityViewController is available under the MIT license.

Copyright © 2013 Roman Efimov.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
