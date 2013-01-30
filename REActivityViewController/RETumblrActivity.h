//
//  RETumblrActivity.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivity.h"
#import "REComposeViewController.h"

@interface RETumblrActivity : REActivity

@property (copy, nonatomic) NSString *consumerKey;
@property (copy, nonatomic) NSString *consumerSecret;

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

@end
