//
//  AppDelegate.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/31/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "RootViewController_iPad.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? [[RootViewController alloc] init] : [[UINavigationController alloc] initWithRootViewController:[[RootViewController_iPad alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[PocketAPI sharedAPI] handleOpenURL:url]){
            return YES;
	} else{
            if ([FBSession.activeSession handleOpenURL:url]) {
                return YES;
            }
    }
    return NO;
}

@end
