//
//  REPrintActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/25/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REPrintActivity.h"
#import "REActivityViewController.h"

@implementation REPrintActivity

- (id)init
{
    return [super initWithTitle:@"Print"
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Print"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        NSDictionary *userInfo = activityViewController.userInfo;
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
                            
                            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
                            printInfo.outputType = UIPrintInfoOutputGeneral;
                            printInfo.jobName = [userInfo objectForKey:@"text"];
                            pc.printInfo = printInfo;
                            
                            pc.printingItem = [userInfo objectForKey:@"image"];
                            
                            void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
                            ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
                                if (!completed && error) {
                                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error."
                                                                                 message:[NSString stringWithFormat:@"An error occured while printing: %@", error]
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil, nil];
                                    
                                    [av show];
                                }
                            };
                            
                            [pc presentAnimated:YES completionHandler:completionHandler];
                        }];
                    }];
}

@end
