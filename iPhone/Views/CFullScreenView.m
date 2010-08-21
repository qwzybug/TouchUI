//
//  CFullScreenView.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

#import "CFullScreenView.h"

#import "UIView_Extensions.h"

@interface CFullScreenView ()
@property (readwrite, nonatomic, assign) NSTimer *autoHideTimer; // No need to be public
@end

#pragma mark -

@implementation CFullScreenView

@synthesize autoHideViews;
@synthesize autoHideStatusBar;
@synthesize autoHideTimer;
@synthesize autoHideDelay;

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != NULL)
	{
	[super setFrame:CGRectMake(0, -64, 320, 480)];
	self.autoHideStatusBar = YES;
	self.autoHideDelay = 5.0;
    }
return(self);
}

- (void)dealloc
{
self.autoHideViews = NULL;
//
[self.autoHideTimer invalidate];
self.autoHideTimer = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)willMoveToWindow:(UIWindow *)newWindow
{
[super willMoveToWindow:newWindow];

if (newWindow != NULL)
	{
	[self setClipsToBoundsRecursively:NO];
	}
else
	{
	[self.autoHideTimer invalidate];
	self.autoHideTimer = NULL;
	//
	if (self.autoHideStatusBar)
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
	//
	for (UIView *theView in self.autoHideViews)
		theView.alpha = 1.0;
	}
}

- (void)didMoveToWindow
{
[super didMoveToWindow];

[self setClipsToBoundsRecursively:NO];
if (self.window && self.autoHideTimer == NULL)
	{
	self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoHideDelay target:self selector:@selector(autoHideTimer:) userInfo:NULL repeats:NO];
	}
}

- (void)setFrame:(CGRect)inFrame
{
[super setFrame:CGRectMake(0, -64, 320, 480)];
}

- (void)showUI;
{
[self.autoHideTimer invalidate];
self.autoHideTimer = NULL;

if (self.autoHideStatusBar)
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];

if (self.autoHideViews != NULL)
	{
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.4];

	for (UIView *theView in self.autoHideViews)
		theView.alpha = 1.0;

	[UIView commitAnimations];
	}

if (self.autoHideTimer == NULL)
	{
	self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoHideDelay target:self selector:@selector(autoHideTimer:) userInfo:NULL repeats:NO];
	}
}

- (void)hideUI;
{
if (self.autoHideStatusBar)
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];

if (self.autoHideViews != NULL)
	{	
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.4];

	for (UIView *theView in self.autoHideViews)
		theView.alpha = 0.0;

	[UIView commitAnimations];
	}
}


- (void)autoHideTimer:(id)inParam
{
self.autoHideTimer = NULL;

[self hideUI];
}

@end
