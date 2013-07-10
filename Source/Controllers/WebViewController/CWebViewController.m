//
//  CWebViewController.m
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

#import "CWebViewController.h"

@interface CWebViewController ()
@property (readwrite, nonatomic, retain) IBOutlet UIWebView *webView;
@property (readwrite, nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (readwrite, nonatomic, retain) IBOutlet UIBarButtonItem *homeButton;
@property (readwrite, nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (readwrite, nonatomic, retain) IBOutlet UIBarButtonItem *forwardsButton;
@property (readwrite, nonatomic, retain) IBOutlet UIBarButtonItem *reloadButton;
@property (readwrite, nonatomic, retain) UIBarButtonItem *activitySpinnerButton;
@property (readwrite, nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;

@end

#pragma mark -

@implementation CWebViewController

@synthesize homeURL;
@synthesize dontChangeTitle;
@synthesize requestedURL;
@synthesize currentURL;
@synthesize webView;
@synthesize toolbar;
@synthesize homeButton;
@synthesize backButton;
@synthesize forwardsButton;
@synthesize reloadButton;
@synthesize activitySpinnerButton;
@synthesize actionButton;

- (id)init
{
if ((self = [self initWithNibName:NULL bundle:NULL]) != NULL)
	{
	}
return(self);
}

- (void)dealloc
{
if (webView.delegate == self)
	webView.delegate = nil;
}

#pragma mark UIViewController

- (void)loadView
{
[super loadView];
//

CGRect theFrame = [UIScreen mainScreen].applicationFrame;

self.view = [[UIView alloc] initWithFrame:theFrame];
self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

//

CGRect theWebViewFrame = self.view.bounds;
self.webView.frame = theWebViewFrame;
[self.view addSubview:self.webView];

if (self.toolbar)
	{
	UIToolbar *theToolbar = self.toolbar;
	CGRect theToolbarFrame = theToolbar.frame;
	
	theWebViewFrame.size.height -= theToolbarFrame.size.height;
	theToolbarFrame.origin.y = CGRectGetMaxY(theWebViewFrame);
	theToolbarFrame.size.width = theWebViewFrame.size.width;

	self.webView.frame = theWebViewFrame;
	theToolbar.frame = theToolbarFrame;
	[self.view addSubview:self.toolbar];
	}
}

- (void)viewDidLoad;
{
[super viewDidLoad];

if (self.homeURL)
	[self loadURL:self.homeURL];

[self updateUI];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
return(YES);
}

#pragma mark -

- (UIWebView *)webView
{
if (webView == NULL)
	{
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.scalesPageToFit = YES;
	webView.dataDetectorTypes = UIDataDetectorTypeLink;
	webView.delegate = self;
	}
return(webView);
}

- (UIToolbar *)toolbar
{
if (toolbar == NULL)
	{
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//	toolbar.barStyle = UIBarStyleBlack;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	
	toolbar.items = [NSArray arrayWithObjects:
		self.homeButton,
		self.backButton,
		self.forwardsButton,
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL],
		self.reloadButton,
		self.actionButton,
		NULL];
	}
return(toolbar);
}

- (UIBarButtonItem *)homeButton
{
if (homeButton == NULL)
	{
	homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-snapback.png"] style:UIBarButtonItemStylePlain target:self action:@selector(home:)];
	}
return(homeButton);
}

- (UIBarButtonItem *)backButton
{
if (backButton == NULL)
	{
	backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
	}
return(backButton);
}

- (UIBarButtonItem *)forwardsButton
{
if (forwardsButton == NULL)
	{
	forwardsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forward:)];
	}
return(forwardsButton);
}

- (UIBarButtonItem *)reloadButton
{
if (reloadButton == NULL)
	{
	reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
	}
return(reloadButton);
}

- (UIBarButtonItem *)activitySpinnerButton
{
if (activitySpinnerButton == NULL)
	{
	UIActivityIndicatorView *theSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[theSpinner startAnimating];
	
	activitySpinnerButton = [[UIBarButtonItem alloc] initWithCustomView:theSpinner];	
	}
return(activitySpinnerButton);
}

- (UIBarButtonItem *)actionButton
{
if (actionButton == NULL)
	{
	actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
	}
return(actionButton);
}

#pragma mark -

- (void)setRequestedURL:(NSURL *)inURL;
{
if (requestedURL != inURL)
	{
	if (requestedURL != NULL)
		{
		requestedURL = NULL;
		}
	
	if (inURL != NULL)
		{
		requestedURL = inURL;

		NSURLRequest *theRequest = [NSURLRequest requestWithURL:inURL];
		[self.webView loadRequest:theRequest];
		}
	}
}

- (BOOL)isHome
{
return([self.currentURL isEqual:self.homeURL]);
}

#pragma mark -

- (void)loadURL:(NSURL *)inURL;
{
if (requestedURL != NULL)
	{
	requestedURL = NULL;
	}
requestedURL = inURL;

NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.requestedURL];
[self.webView loadRequest:theRequest];
}

- (void)updateUI
{
self.homeButton.enabled = !self.isHome;

self.backButton.enabled = self.webView.canGoBack;
self.forwardsButton.enabled = self.webView.canGoForward;

self.actionButton.enabled = !self.webView.loading;

if (self.webView.loading == YES)
	{
	UIBarButtonItem *theBarButtonItem = self.activitySpinnerButton;
	NSMutableArray *theItems = [self.toolbar.items mutableCopy];
	NSInteger theIndex = [theItems indexOfObject:self.reloadButton];
	if (theIndex != NSNotFound)
		{
		[theItems replaceObjectAtIndex:theIndex withObject:theBarButtonItem];
		self.toolbar.items = theItems;
		}
	}
else
	{
	UIBarButtonItem *theBarButtonItem = self.reloadButton;
	NSMutableArray *theItems = [self.toolbar.items mutableCopy];
	NSInteger theIndex = [theItems indexOfObject:self.activitySpinnerButton];
	if (theIndex != NSNotFound)
		{
		[theItems replaceObjectAtIndex:theIndex withObject:theBarButtonItem];
		self.toolbar.items = theItems;
		}
	}
}

- (void)resetWebView
{
CGRect theFrame = self.webView.frame;

[webView removeFromSuperview];
webView = NULL;

self.webView.frame = theFrame;
[self.view addSubview:self.webView];
}

- (void)hideToolbar
{
if (!self.toolbar.hidden)
	{
	CGRect theWebViewFrame = self.webView.frame;
	CGRect theToolbarFrame = self.toolbar.frame;
	theWebViewFrame.size.height += theToolbarFrame.size.height;
	self.webView.frame = theWebViewFrame;
	self.toolbar.hidden = YES;
	}
}

- (void)showToolbar
{
if (self.toolbar.hidden)
	{
	CGRect theWebViewFrame = self.webView.frame;
	CGRect theToolbarFrame = self.toolbar.frame;
	theWebViewFrame.size.height -= theToolbarFrame.size.height;
	self.webView.frame = theWebViewFrame;
	self.toolbar.hidden = NO;
	}
}

#pragma mark -

- (IBAction)back:(id)inSender
{
[self.webView goBack];
}

- (IBAction)forward:(id)inSender
{
[self.webView goForward];
}

- (IBAction)reload:(id)inSender
{
[self.webView reload];
}

- (IBAction)home:(id)inSender
{
if (self.homeURL)
	[self loadURL:self.homeURL];
}

- (IBAction)action:(id)inSender
{
//CURLOpener *theActionSheet = [[CURLOpener alloc] initWithParentViewController:self URL:self.currentURL];
//
//if ([theActionSheet respondsToSelector:@selector(showFromBarButtonItem:animated:)])
//	[theActionSheet showFromBarButtonItem:inSender animated:YES];
//else
//	[theActionSheet showFromToolbar:self.toolbar];
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
return(YES);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
[self updateUI];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
if (!self.dontChangeTitle)
	self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];

self.currentURL = [[NSURL URLWithString:[self.webView stringByEvaluatingJavaScriptFromString:@"window.location.href"]] standardizedURL];

[self updateUI];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
[self updateUI];
}

@end
