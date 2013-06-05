//
//  REChromeActivity.h
//  Food(ness)
//
//  Created by Neil Kimmett on 04/06/2013.
//  Copyright (c) 2013 Marks & Spencer. All rights reserved.
//

#import "REActivity.h"

@interface REChromeActivity : REActivity

- (id)init;

// N.B. To use callbackURL you'll need to register a URL scheme in your Info.plist (more info here https://developers.google.com/chrome/mobile/docs/ios-links )
- (id)initWithCallbackURL:(NSURL *)callbackURL;

@end
