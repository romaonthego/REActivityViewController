//
//  REActivityDelegateObject.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REActivityDelegateObject.h"

@implementation REActivityDelegateObject

static REActivityDelegateObject *_sharedObject = nil;

+ (REActivityDelegateObject *)sharedObject
{
    if (_sharedObject != nil) {
        return _sharedObject;
    }
    
    @synchronized(self) {
        if (_sharedObject == nil) {
            _sharedObject = [[self alloc] init];
        }
    }
    
    return _sharedObject;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

@end
