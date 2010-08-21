//
//  CURLOpener.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/07/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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

#import "CURLOpener.h"

#import <MessageUI/MessageUI.h>

static CURLOpener *gInstance = NULL;

@interface CURLOpener ()
@property (readwrite, nonatomic, retain) NSArray *selectors;

- (void)addButtonsForURL:(NSURL *)inURL;
@end

#pragma mark -

@implementation CURLOpener

@synthesize parentViewController;
@synthesize URL;
@synthesize selectors;

- (id)initWithParentViewController:(UIViewController *)inViewController URL:(NSURL *)inURL
{
if ((self = [super initWithTitle:NULL delegate:self cancelButtonTitle:NULL destructiveButtonTitle:NULL otherButtonTitles:NULL, NULL]) != NULL)
	{
	parentViewController = inViewController;
	URL = [inURL retain];


	[self addButtonsForURL:inURL];

	[self addButtonWithTitle:@"Cancel"];
	self.cancelButtonIndex = self.numberOfButtons - 1;
	
	if (gInstance)
		{
		[gInstance release];
		gInstance = NULL;
		}

	gInstance = [self retain];
	}
return(self);
}

- (void)addButtonsForURL:(NSURL *)inURL
{
NSMutableArray *theSelectors = [NSMutableArray array];

if ([inURL.scheme isEqual:@"http"])
	{
	[self addButtonWithTitle:@"Open in Safari"];
	[theSelectors addObject:NSStringFromSelector(@selector(openURL:))];
	}

if (YES)
	{
	[self addButtonWithTitle:@"E-mail Link"];
	[theSelectors addObject:NSStringFromSelector(@selector(mailURL:))];
	}

self.selectors = theSelectors;
}

#pragma mark -

- (void)openURL:(NSURL *)inURL
{
[[UIApplication sharedApplication] openURL:inURL];
}

- (void)mailURL:(NSURL *)inURL
{
MFMailComposeViewController *theViewController = [[[MFMailComposeViewController alloc] init] autorelease];
theViewController.mailComposeDelegate = self;
[theViewController setMessageBody:[inURL absoluteString] isHTML:NO];

[self.parentViewController presentModalViewController:theViewController animated:YES];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
if (buttonIndex < self.selectors.count)
	{
	NSString *theSelectorName = [self.selectors objectAtIndex:buttonIndex];
	SEL theSelector = NSSelectorFromString(theSelectorName);
	[self performSelector:theSelector withObject:self.URL];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
