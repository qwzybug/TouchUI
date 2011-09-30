//
//  CURLOpener.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/07/10.
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

#import "CURLOpener.h"

#import <MessageUI/MessageUI.h>

static CURLOpener *gInstance = NULL;

@interface CURLOpener ()
@property (readwrite, nonatomic, retain) NSArray *selectors;
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
	URL = inURL;

	[self addButtonsForURL:inURL];

	[self addButtonWithTitle:@"Cancel"];
	self.cancelButtonIndex = self.numberOfButtons - 1;
	
	if (gInstance)
		{
		gInstance = NULL;
		}

	gInstance = self;
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
MFMailComposeViewController *theViewController = [[MFMailComposeViewController alloc] init];
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
