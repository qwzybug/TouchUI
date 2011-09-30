//
//  CFakeSplitViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/19/10.
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

#import "CFakeSplitViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation CFakeSplitViewController

@synthesize masterViewController;
@synthesize detailViewController;

- (void)loadView
{
UIView *theDrawingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];

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
masterViewController = NULL;
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
		
		masterViewController = NULL;
		}
		
	if (inMasterViewController != NULL)
		{
		masterViewController = inMasterViewController;
		
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
		
		detailViewController = NULL;
		}
		
	if (inDetailViewController != NULL)
		{
		detailViewController = inDetailViewController;
		
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
