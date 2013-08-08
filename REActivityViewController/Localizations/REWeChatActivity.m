//
// REWeChatActivity.m
// REActivityViewController
//
// Copyright (c) 2013 Jason Hao (https://github.com/hjue )
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

#import "REWeChatActivity.h"
#import "REActivityViewController.h"
#import "WXApi.h"
#import "UIImage+Resize.h"

@implementation REWeChatActivity

- (id)initWithAppId:(NSString *)appId messageType:(int)messageType scene:(int)scene
{

    if (scene == WXSceneSession) {
        self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.WeChat.title", @"REActivityViewController",  @"WeChat")
                              image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Wechat"]
                        actionBlock:nil];
    }else
    {
        self = [super initWithTitle:NSLocalizedStringFromTable(@"activity.WeChatTimeline.title", @"REActivityViewController", @"WeChatTimeline")
                              image:[UIImage imageNamed:@"REActivityViewController.bundle/Icon_Wechat_Timeline"]
                        actionBlock:nil];
    }

    if (!self)
        return nil;
    
    _appId = appId;
    _scene = scene;
    _messageType = messageType;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            NSString *text = [userInfo objectForKey:@"text"];
            NSString *description = [userInfo objectForKey:@"description"];            
            UIImage *image = [userInfo objectForKey:@"image"];
            NSURL *url = [userInfo objectForKey:@"url"];
            
            WXMediaMessage *message = [WXMediaMessage message];
            if (image)
            {
                [message setThumbImage:[image resizedImageByMagick: @"140x140"]];
            }
            
            if (text) {
                [message setTitle:text];
            }
            
            if (description) {
                [message setDescription:description];
            }
            
            
            if (weakSelf.messageType == WXMessageTypeImage && image) {
                
                WXImageObject *ext = [WXImageObject object];
                ext.imageData = UIImagePNGRepresentation(image); 
                message.mediaObject = ext;
                
            }else if (weakSelf.messageType == WXMessageTypeNews)
            {
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = [url absoluteString];
                message.mediaObject = ext;
                
            }else if (weakSelf.messageType == WXMessageTypeMusic)
            {
                WXMusicObject *ext = [WXMusicObject object];
                ext.musicUrl = [url absoluteString];
                NSURL *musicDataUrl = [userInfo objectForKey:@"musicDataUrl"];
                ext.musicDataUrl = [musicDataUrl absoluteString];
                message.mediaObject = ext;
                
            }else if (weakSelf.messageType == WXMessageTypeVideo)
            {
                WXVideoObject *ext = [WXVideoObject object];
                ext.videoUrl = [url absoluteString];
                message.mediaObject = ext;
                
            }else if (weakSelf.messageType == WXMessageTypeApp)
            {
                WXAppExtendObject *ext = [WXAppExtendObject object];
                ext.url = [url absoluteString];
                
                NSString *extInfo = [userInfo objectForKey:@"extInfo"];
                NSData *fileData = [userInfo objectForKey:@"fileData"];
                if (extInfo) {
                    ext.extInfo = extInfo;
                }
                if (fileData) {
                    ext.fileData = fileData;
                }
                message.mediaObject = ext;
                
                
            }else if (weakSelf.messageType == WXMessageTypeEmoticon)
            {
                
                WXEmoticonObject *ext = [WXEmoticonObject object];
                ext.emoticonData = UIImagePNGRepresentation(image);
                message.mediaObject = ext;
                
            }else  //WXMessageTypeText
            {
                
            }
            
            if (weakSelf.messageType == WXMessageTypeText) {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = YES;
                req.text = text;
                req.scene = weakSelf.scene;
                [WXApi sendReq:req];
            }else{
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = weakSelf.scene;                
                [WXApi sendReq:req];
            }
            

            
        }];
    };
    
    return self;
    
    
}

- (void) sendImageContentWithImage:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendNewsContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"麦当劳“销售过期食品”其实不是卫生问题";
    message.description = @"3.15晚会播出当晚，麦当劳该店所在辖区的卫生、工商部门就连夜登门调查，并对腾讯财经等媒体公布初步结果；而尽管未接到闭店处罚通知，麦当劳中国总部还是在发布道歉声明后暂停了该店营业。\
    \
    不得不承认，麦当劳“销售过期食品”固然是事实，但这个“过期”仅仅是他们自己定义的过期，普通中国家庭也不会把刚炸出来30分钟的鸡翅拿去扔掉。麦当劳在食品卫生上的严格程度，不仅远远超出了一般国内企业，而且也超出了一般中国民众的心理预期和生活想象。大多数人以前并不知道，麦当劳厨房的食品架上还有计时器，辣鸡翅等大多数食品存放半个小时之后，按规定就应该扔掉。也正因如此，甚至有网友认为央视3.15晚会的曝光是给麦当劳做的软广告。\
    \
    央视视频中反映的情况，除了掉到地上的的食品未经任何处理继续加工显得很过分外，其它的问题都源于麦当劳自己制定的标准远远超出了国内一般快餐店的标准。比如北京市卫生监督所相关负责人介绍，麦当劳内部要求熟菜在70℃环境下保存2小时，是为了保存食品风味，属于企业内部卫生规范。目前的检查结果显示，麦当劳的保温盒温度在93℃，但在这种环境下保存的熟菜即便超过2小时，对公众也没有危害。也就是说麦当劳的一些保持时间标准是基于保持其食品的独特风味的要求，并非食品发生变质可能损害消费者身体健康的标准，麦当劳这家门店超时存放食品的行为，违反的是企业制定的内部标准，并不违反食品安全规定，政府应该依据法律法规来监管食品卫生，而不是按照食品公司自己制定的标准，从这个角度来看，麦当劳在食品卫生上没有责任（除了使用掉在地上的食物）。…[详细]\
    \
    但三里屯麦当劳的行为确实违背了诚信\
    麦当劳的内部卫生规定虽然并未被作为卖点进行宣扬，但洋快餐在中国是便捷和卫生的代名词，却是不争的事实。谁也不是活雷锋，麦当劳制定的严苛内部标准，为的是树立自己的品牌优势，进而在市场定位上取得明显的价格优势，或者说让自己“贵得有理由”。但如果他的员工在执行上不能贯彻这一企业标准，相对于其价格水平而言，就有欺诈和损害消费者权益之嫌，这也是不言而喻的。从这个意义上来说，央视曝光麦当劳的问题并无不妥，麦当劳至少涉嫌消费欺诈，因为它没有向消费者提供它向人们承诺的标准的食品。也就是说，工商部门而非食品卫生监管部门约谈麦当劳，也并非师出无名。";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://view.news.qq.com/zt2012/mdl/index.htm";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)shareFromViewController:(UIViewController *)viewController text:(NSString *)text url:(NSURL *)url image:(UIImage *)image
{
    
}
@end
