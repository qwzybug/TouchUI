//
//  CWebViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/27/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CWebViewController.h"

#import "CURLOpener.h"

@interface CWebViewController ()
@property (readwrite, nonatomic, retain) NSURL *currentURL;

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
if ((self = [super initWithNibName:NULL bundle:NULL]) != NULL)
	{
	}
return(self);
}

- (void)dealloc
{

//
[super dealloc];
}

#pragma mark UIViewController

- (void)loadView
{
[super loadView];
//

CGRect theFrame = [UIScreen mainScreen].applicationFrame;

self.view = [[[UIView alloc] initWithFrame:theFrame] autorelease];
self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

//

CGRect theWebViewFrame = self.view.bounds;
self.webView.frame = theWebViewFrame;
[self.view addSubview:self.webView];

if (YES)
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
		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL] autorelease],
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
	UIActivityIndicatorView *theSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
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
		[requestedURL release];
		requestedURL = NULL;
		}
	
	if (inURL != NULL)
		{
		requestedURL = [inURL retain];

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
	[requestedURL release];
	requestedURL = NULL;
	}
requestedURL = [inURL retain];

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
	NSMutableArray *theItems = [[self.toolbar.items mutableCopy] autorelease];
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
	NSMutableArray *theItems = [[self.toolbar.items mutableCopy] autorelease];
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
[webView release];
webView = NULL;

self.webView.frame = theFrame;
[self.view addSubview:self.webView];
}

- (void)hideToolbar
{
self.toolbar.hidden = YES;
}

- (void)showToolbar
{
self.toolbar.hidden = NO;
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
CURLOpener *theActionSheet = [[[CURLOpener alloc] initWithParentViewController:self URL:self.currentURL] autorelease];

if ([theActionSheet respondsToSelector:@selector(showFromBarButtonItem:animated:)])
	[theActionSheet showFromBarButtonItem:inSender animated:YES];
else
	[theActionSheet showFromToolbar:self.toolbar];
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
