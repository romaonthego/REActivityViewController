//
//  REInstapaperActivity.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REInstapaperActivity.h"
#import "REActivityViewController.h"
#import "AFNetworking.h"

@implementation REInstapaperActivity

- (id)init
{
    return [super initWithTitle:@"Send to Instapaper"
                          image:[UIImage imageNamed:@"Icon_Instapaper"]
                    actionBlock:^(REActivity *activity, REActivityViewController *activityViewController) {
                        NSURL *url = [NSURL URLWithString:@"https://www.instapaper.com/api/add"];
                        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
                
                        [httpClient setAuthorizationHeaderWithUsername:@"romefimov@gmail.com" password:@""];
                        NSDictionary *params = @{
                            @"title": @"TEXT 123",
                            @"url": @"https://github.com/romaonthego"
                        };
                        [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                            NSLog(@"Request Successful, response '%@'", responseStr);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
                        }];
                    }];
}

@end
