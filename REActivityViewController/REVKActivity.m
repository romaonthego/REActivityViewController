//
//  REVKActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REVKActivity.h"
#import "REActivityViewController.h"
#import "REVKActivityViewController.h"

@implementation REVKActivity

- (id)initWithClientId:(NSString *)clientId
{
    self = [super initWithTitle:@"VKontakte"
                          image:[UIImage imageNamed:@"Icon_VK"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        UIViewController *presenter = activityViewController.presentingController;
                        [activityViewController dismissViewControllerAnimated:YES completion:^{
                            
                            REVKActivityViewController *vkController = [[REVKActivityViewController alloc] initWithClientId:_clientId];
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vkController];
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                            
                            [presenter presentViewController:navigationController animated:YES completion:^{
                          //      presenter.modalPresentationStyle = UIModalPresentationFullScreen;
                            }];
                        }];
                    }];
    if (self) {
        self.clientId = clientId;
    }
    return self;
}

- (void)share
{
    UIViewController *presenter = self.activityViewController.presentingController;
    NSDictionary *userInfo = self.activityViewController.userInfo;

    REComposeViewController *controller = [[REComposeViewController alloc] init];
    controller.title = @"VKontakte";
    controller.navigationBar.tintColor = [UIColor colorWithRed:56/255.0f green:99/255.0f blue:150/255.0f alpha:1.0];
    if ([userInfo objectForKey:@"text"])
        controller.text = [userInfo objectForKey:@"text"];
    controller.completionHandler = ^(REComposeResult result){
        presenter.modalPresentationStyle = UIModalPresentationFullScreen;
    };
    presenter.modalPresentationStyle = UIModalPresentationCurrentContext;
    [presenter presentViewController:controller animated:YES completion:nil];
}

@end
