    //
//  CFakeSplitViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/19/10.
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

#import "CFakeSplitViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation CFakeSplitViewController

@synthesize masterViewController;
@synthesize detailViewController;

- (void)dealloc
{
[masterViewController release];
masterViewController = NULL;
[detailViewController release];
detailViewController = NULL;
//
[super dealloc];
}

- (void)loadView
{
UIView *theDrawingView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

CALayer *theLayer = [CALayer layer];
theLayer.frame = theDrawingView.bounds;
theLayer.delegate = self;
[theLayer setNeedsDisplay];
[theDrawingView.layer addSublayer:theLayer];

theDrawingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

self.view = theDrawingView;
}

- (void)viewDidUnload
{
[super viewDidUnload];
//
[masterViewController release];
masterViewController = NULL;
[detailViewController release];
detailViewController = NULL;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return(YES);
}

#pragma mark -

- (void)setMasterViewController:(UIViewController *)inMasterViewController
{
if (masterViewController != inMasterViewController)
	{
	if (masterViewController != NULL)
		{
		[masterViewController viewWillDisappear:NO];
		[masterViewController.view removeFromSuperview];
		[masterViewController viewDidDisappear:NO];
		
		[masterViewController release];
		masterViewController = NULL;
		}
		
	if (inMasterViewController != NULL)
		{
		masterViewController = [inMasterViewController retain];
		
		[masterViewController viewWillAppear:NO];

		UIView *theMasterView = self.masterViewController.view;
		theMasterView.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height);
		theMasterView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		
		[self.view addSubview:theMasterView];

		[masterViewController viewDidAppear:NO];
		}
	}
}

- (void)setDetailViewController:(UIViewController *)inDetailViewController
{
if (detailViewController != inDetailViewController)
	{
	if (detailViewController != NULL)
		{
		[detailViewController viewWillDisappear:NO];
		[detailViewController.view removeFromSuperview];
		[detailViewController viewDidDisappear:NO];
		
		[detailViewController release];
		detailViewController = NULL;
		}
		
	if (inDetailViewController != NULL)
		{
		detailViewController = [inDetailViewController retain];
		
		[detailViewController viewWillAppear:NO];

		UIView *theDetailView = self.detailViewController.view;
		theDetailView.frame = CGRectMake(321.0, 0.0, self.view.bounds.size.width - 321.0, self.view.bounds.size.height);
		theDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:theDetailView];

		[detailViewController viewDidAppear:NO];
		}
	}
}

#pragma mark -

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
CGContextMoveToPoint(ctx, 320, 0);
CGContextAddLineToPoint(ctx, 320, 10000);
CGContextStrokePath(ctx);
}

@end
