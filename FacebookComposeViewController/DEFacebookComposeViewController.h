//
//  DETwitterComposeViewController.h
//  DETwitter
//
//  Copyright (c) 2011-2012 Double Encore, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
//  in the documentation and/or other materials provided with the distribution. Neither the name of the Double Encore Inc. nor the names of its 
//  contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
//  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS 
//  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
//  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

//  RENAMED to
//  DEFacebookComposeViewController.h
//  DEFacebook
//
//  Modified by Vladmir on 03/09/2012.
//  www.developers-life.com




@class DEFacebookSheetCardView;
@class DEFacebookTextView;

@interface DEFacebookComposeViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate,
UIPopoverControllerDelegate>

@property (retain, nonatomic) IBOutlet DEFacebookSheetCardView *cardView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *sendButton;
@property (retain, nonatomic) IBOutlet UIView *cardHeaderLineView;
@property (retain, nonatomic) IBOutlet DEFacebookTextView *textView;
@property (retain, nonatomic) IBOutlet UIView *textViewContainer;
@property (retain, nonatomic) IBOutlet UIImageView *paperClipView;
@property (retain, nonatomic) IBOutlet UIImageView *attachment1FrameView;
@property (retain, nonatomic) IBOutlet UIImageView *attachment2FrameView;
@property (retain, nonatomic) IBOutlet UIImageView *attachment3FrameView;
@property (retain, nonatomic) IBOutlet UIImageView *attachment1ImageView;
@property (retain, nonatomic) IBOutlet UIImageView *attachment2ImageView;
@property (retain, nonatomic) IBOutlet UIImageView *attachment3ImageView;
@property (retain, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (assign, nonatomic) IBOutlet UIImageView *navImage;

    // Public
- (IBAction)send;
- (IBAction)cancel;

enum DEFacebookComposeViewControllerResult {
    DEFacebookComposeViewControllerResultCancelled,
    DEFacebookComposeViewControllerResultDone
};


typedef enum DEFacebookComposeViewControllerResult DEFacebookComposeViewControllerResult;

    // Completion handler for DEFacebookComposeViewController
typedef void (^DEFacebookComposeViewControllerCompletionHandler)(DEFacebookComposeViewControllerResult result); 


    // Sets the initial text to be tweeted. Returns NO if the specified text will
    // not fit within the character space currently available, or if the sheet
    // has already been presented to the user.
- (BOOL)setInitialText:(NSString *)text;

    // Adds an image to the tweet. Returns NO if the additional image will not fit
    // within the character space currently available, or if the sheet has already
    // been presented to the user.
- (BOOL)addImage:(UIImage *)image;

//    // Adds a URL to the tweet. Returns NO if the additional URL will not fit
//    // within the character space currently available, or if the sheet has already
//    // been presented to the user.
//- (BOOL)addImageWithURL:(NSURL *)url;

    // Removes all images from the tweet. Returns NO and does not perform an operation
    // if the sheet has already been presented to the user. 
- (BOOL)removeAllImages;

    // Adds a URL to the tweet. Returns NO if the additional URL will not fit
    // within the character space currently available, or if the sheet has already
    // been presented to the user.
- (BOOL)addURL:(NSURL *)url;

//    // Removes all URLs from the tweet. Returns NO and does not perform an operation
//    // if the sheet has already been presented to the user.
//- (BOOL)removeAllURLs;

    // Specify a block to be called when the user is finished. This block is not guaranteed
    // to be called on any particular thread.
@property (nonatomic, copy) DEFacebookComposeViewControllerCompletionHandler completionHandler;

@property (nonatomic, copy) NSDictionary *customParameters;

    // Force use SLComposeViewController on iOS 6 or not
- (id)initForceUseCustomController:(BOOL)custom;

// Adds url scheme suffix for DEFacebookComposeViewController (ignored for SLComposeViewController)
- (id)initForceUseCustomController:(BOOL)custom urlSchemeSuffix:(NSString *)urlSchemeSuffix;

@end
