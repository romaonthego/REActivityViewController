//
// REVKActivity.m
// REActivityViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REVKActivity.h"
#import "REActivityViewController.h"
#import "REVKActivityViewController.h"
#import "AFNetworking.h"

@implementation REVKActivity

- (id)initWithClientId:(NSString *)clientId
{
    self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.VKontakte.title", @"REActivityViewController", @"VKontakte")
                          image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_VK"]
                    actionBlock:nil];
    if (!self)
        return nil;
    
    _clientId = clientId;
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        UIViewController *presenter = activityViewController.presentingController;
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"REVKActivity_Token"];
            if (token) {
                [weakSelf share];
            } else {
                REVKActivityViewController *vkController = [[REVKActivityViewController alloc] initWithClientId:weakSelf.clientId];
                vkController.activity = weakSelf;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vkController];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                
                [presenter presentViewController:navigationController animated:YES completion:nil];
            }
        }];
    };
    
    return self;
}

- (void)share
{
    __typeof(&*self) __weak weakSelf = self;

    NSDictionary *userInfo = self.userInfo ? self.userInfo : self.activityViewController.userInfo;

    NSString *text = [userInfo objectForKey:@"text"];
    NSURL *url = [userInfo objectForKey:@"url"];
    UIImage *image = [userInfo objectForKey:@"image"];
    
    NSString *textToShare;
    if (text && !url)
        textToShare = text;
    
    if (!text && url)
        textToShare = url.absoluteString;
    
    if (text && url)
        textToShare = [NSString stringWithFormat:@"%@ %@", text, url.absoluteString];
    
    REComposeViewController *controller = [[REComposeViewController alloc] init];
    controller.title = NSLocalizedStringFromTable(@"activity.VKontakte.dialog.title", @"REActivityViewController", @"VKontakte");
    controller.navigationBar.tintColor = [UIColor colorWithRed:56/255.0f green:99/255.0f blue:150/255.0f alpha:1.0];
    if (textToShare)
        controller.text = textToShare;
    if (image) {
        controller.hasAttachment = YES;
        controller.attachmentImage = image;
    }
    controller.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
        [composeViewController dismissViewControllerAnimated:YES completion:nil];
        if (result == REComposeResultPosted) {
            if (image) {
                [weakSelf shareText:composeViewController.text image:image];
            } else {
                [weakSelf shareText:composeViewController.text];
            }
        }
    };
    
    UIViewController *presentingViewController = self.activityViewController.rootViewController ? self.activityViewController.rootViewController : self.activityViewController.presentingController;
    [controller presentFromViewController:presentingViewController];
}

#pragma mark -
#pragma mark VK sharing

- (void)requestPhotoUploadURLWithSuccess:(void (^)(NSString *uploadURL))success
{
    NSString *serverURL = [NSString stringWithFormat:@"https://api.vk.com/method/photos.getWallUploadServer?owner_id=%@&access_token=%@", self.ownerId, self.token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            success([[JSON objectForKey:@"response"] objectForKey:@"upload_url"]);
        }
    } failure:nil];
    [operation start];
}

- (void)uploadImage:(UIImage *)image toURL:(NSString *)urlString success:(void (^)(NSString *hash, NSString *photo, NSString *server))success
{
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75f);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil
                                                    constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpg"];
    }];
    
    void (^parseJSON)(id JSON) = ^(id JSON){
        if (success)
            success([JSON objectForKey:@"hash"], [JSON objectForKey:@"photo"], [JSON objectForKey:@"server"]);
    };
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        parseJSON(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        parseJSON(JSON);
    }];
    [operation start];
}

- (void)saveImageToWallWithHash:(NSString *)hash photo:(NSString *)photo server:(NSString *)server success:(void (^)(NSString *wallPhotoId))success
{
    NSString *serverURL = [NSString stringWithFormat:@"https://api.vk.com/method/photos.saveWallPhoto?owner_id=%@&access_token=%@&server=%@&photo=%@&hash=%@", self.ownerId, self.token, server, photo, hash];
    NSString *escapedURL = [serverURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedURL]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success)
            success([[[JSON objectForKey:@"response"] objectAtIndex:0] objectForKey:@"id"]);
    } failure:nil];
    [operation start];
}

- (void)shareOnWall:(NSString *)text photoId:(NSString *)wallPhotoId completion:(void (^)(void))completion
{
    NSString *serverURL;
    
    if (wallPhotoId) {
        serverURL = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@&attachment=%@", self.ownerId, self.token, [self URLEncodedString:text], wallPhotoId];
    } else {
        serverURL = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@", self.ownerId, self.token, [self URLEncodedString:text]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
        
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (completion)
            completion();
    } failure:nil];
    [operation start];
}

- (void)shareText:(NSString *)text image:(UIImage *)image
{
    __typeof(&*self) __weak weakSelf = self;
    
    [self requestPhotoUploadURLWithSuccess:^(NSString *uploadURL) {
        [weakSelf uploadImage:image toURL:uploadURL success:^(NSString *hash, NSString *photo, NSString *server) {
            [weakSelf saveImageToWallWithHash:hash photo:photo server:server success:^(NSString *wallPhotoId) {
                [weakSelf shareOnWall:text photoId:wallPhotoId completion:nil];
            }];
        }];
    }];
}

- (void)shareText:(NSString *)text
{
    [self shareOnWall:text photoId:nil completion:nil];
}

#pragma mark -
#pragma mark Helper

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																							 (CFStringRef)str,
																							 NULL,
																							 CFSTR("!*'();:@&=+$,/?%#[]"),
																							 kCFStringEncodingUTF8);
	return result;
}

#pragma mark -
#pragma mark Credentials

- (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"REVKActivity_Token"];
}

- (NSString *)ownerId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"REVKActivity_UserId"];
}

@end
