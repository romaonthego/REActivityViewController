//
//  REActivityDelegateObject.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface REActivityDelegateObject : NSObject <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIViewController *controller;

+ (REActivityDelegateObject *)sharedObject;

@end
