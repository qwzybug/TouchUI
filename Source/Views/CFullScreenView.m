//
//  CFullScreenView.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/13/09.
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
[autoHideTimer invalidate];
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
