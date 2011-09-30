//
//  CWebViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 05/27/08.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import <UIKit/UIKit.h>

@interface CWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	NSURL *homeURL;
	BOOL dontChangeTitle;
	
	NSURL *__unsafe_unretained requestedURL;
	NSURL *currentURL;

	IBOutlet UIWebView *webView;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UIBarButtonItem *homeButton;
	IBOutlet UIBarButtonItem *backButton;
	IBOutlet UIBarButtonItem *forwardsButton;
	IBOutlet UIBarButtonItem *reloadButton;
	IBOutlet UIBarButtonItem *activitySpinnerButton;
	IBOutlet UIBarButtonItem *actionButton;	
}

@property (readwrite, nonatomic, retain) NSURL *homeURL;
@property (readwrite, nonatomic, assign) BOOL dontChangeTitle;

@property (readwrite, nonatomic, assign) NSURL *requestedURL;
@property (readwrite, nonatomic, retain) NSURL *currentURL;
@property (readonly, nonatomic, assign) BOOL isHome;

@property (readonly, nonatomic, retain) IBOutlet UIWebView *webView;
@property (readonly, nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (readonly, nonatomic, retain) IBOutlet UIBarButtonItem *homeButton;
@property (readonly, nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (readonly, nonatomic, retain) IBOutlet UIBarButtonItem *forwardsButton;
@property (readonly, nonatomic, retain) IBOutlet UIBarButtonItem *reloadButton;
@property (readonly, nonatomic, retain) IBOutlet UIBarButtonItem *activitySpinnerButton;
@property (readonly, nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;

- (void)loadURL:(NSURL *)inURL;
- (void)updateUI;
- (void)resetWebView;

- (void)hideToolbar;
- (void)showToolbar;

- (IBAction)back:(id)inSender;
- (IBAction)forward:(id)inSender;
- (IBAction)reload:(id)inSender;
- (IBAction)home:(id)inSender;
- (IBAction)action:(id)inSender;

@end
