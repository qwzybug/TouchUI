//
//  UIView_AnimationExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/9/09.
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

#import "UIView_AnimationExtensions.h"

@interface UIView_AnimationExtensionsHelper : NSObject 

@end

@implementation UIView_AnimationExtensionsHelper

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
if ([animationID isEqualToString:@"TODO_ADD"])
	{
		UIView *theSubview = context;
		
		[theSubview retain];
		
		UIView *theMaskView = theSubview.superview;
		UIView *theParentView = theMaskView.superview;
		theSubview.frame = theMaskView.frame;
		[theSubview removeFromSuperview];
		[theParentView addSubview:theSubview];
		[theMaskView removeFromSuperview];
		
		[theSubview release];
	}
	else if ([animationID isEqualToString:@"TODO_REMOVE"])
	{
		UIView *theSubview = context;
		
		UIView *theMaskView = theSubview.superview;
		[theMaskView removeFromSuperview];
	}
	else if ([animationID isEqualToString:@"TODO_FADE_OUT"])
	{
		UIView *theSubview = context;
		[theSubview removeFromSuperview];
	}
	
	[self release];
}

@end

@implementation UIView (UIView_AnimationExtensions)

- (void)addSubview:(UIView *)inSubview withAnimationType:(EViewAnimationType)inAnimationType
{
if (inAnimationType == ViewAnimationType_SlideDown
	|| inAnimationType == ViewAnimationType_SlideUp
	|| inAnimationType == ViewAnimationType_SlideLeft
	|| inAnimationType == ViewAnimationType_SlideRight)
	{
	CGRect theFrame = inSubview.frame;

	UIView *theMaskView = [[[UIView alloc] initWithFrame:theFrame] autorelease];
	//theMaskView.backgroundColor = [UIColor greenColor];
	theMaskView.opaque = NO;
	theMaskView.clipsToBounds = YES;

	theFrame.origin = CGPointZero;

	switch (inAnimationType)
		{
		case ViewAnimationType_SlideDown:
			theFrame.origin.y -= theFrame.size.height;
			break;
		case ViewAnimationType_SlideUp:
			theFrame.origin.y += theFrame.size.height;
			break;
		case ViewAnimationType_SlideLeft:
			theFrame.origin.x += theFrame.size.width;
			break;
		case ViewAnimationType_SlideRight:
			theFrame.origin.x -= theFrame.size.width;
			break;
		case ViewAnimationType_FadeIn:
		case ViewAnimationType_FadeOut:
            NSAssert(NO, @"Not implemented");
            break;
		}

	inSubview.frame = theFrame;

	[theMaskView addSubview:inSubview];

	[self addSubview:theMaskView];

	[UIView beginAnimations:@"TODO_ADD" context:inSubview];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationDelegate:[[UIView_AnimationExtensionsHelper alloc] init]];

	inSubview.frame = theMaskView.bounds;

	[UIView commitAnimations];
	}
else if (inAnimationType == ViewAnimationType_FadeIn)
	{
	inSubview.alpha = 0.0f;
	[self addSubview:inSubview];

	[UIView beginAnimations:@"TODO_FADE_IN" context:inSubview];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationDelegate:[[UIView_AnimationExtensionsHelper alloc] init]];

	inSubview.alpha = 1.0f;

	[UIView commitAnimations];
	}
}

- (void)removeFromSuperviewWithAnimationType:(EViewAnimationType)inAnimationType
{
if (inAnimationType == ViewAnimationType_SlideDown
	|| inAnimationType == ViewAnimationType_SlideUp
	|| inAnimationType == ViewAnimationType_SlideLeft
	|| inAnimationType == ViewAnimationType_SlideRight)
	{
	CGRect theFrame = self.frame;
	UIView *theSuperView = self.superview;
	UIView *theMaskView = [[[UIView alloc] initWithFrame:theFrame] autorelease];
	[theSuperView addSubview:theMaskView];
	[self retain];
	[self removeFromSuperview];
	theFrame.origin = CGPointZero;
	self.frame = theFrame;

	[theMaskView addSubview:self];
	[self release];

	[UIView beginAnimations:@"TODO_REMOVE" context:self];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:[[UIView_AnimationExtensionsHelper alloc] init]];

	theFrame.origin = CGPointZero;

	switch (inAnimationType)
		{
		case ViewAnimationType_SlideDown:
			theFrame.origin.y += theFrame.size.height;
			break;
		case ViewAnimationType_SlideUp:
			theFrame.origin.y -= theFrame.size.height;
			break;
		case ViewAnimationType_SlideLeft:
			theFrame.origin.x -= theFrame.size.width;
			break;
		case ViewAnimationType_SlideRight:
			theFrame.origin.x += theFrame.size.width;
			break;
		case ViewAnimationType_FadeIn:
		case ViewAnimationType_FadeOut:
            NSAssert(NO, @"Not implemented");
            break;
		}

	self.frame = theFrame;

	[UIView commitAnimations];
	}
else if (inAnimationType == ViewAnimationType_FadeOut)
	{
	[UIView beginAnimations:@"TODO_FADE_OUT" context:self];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:[[UIView_AnimationExtensionsHelper alloc] init]];

	self.alpha = 0.0f;

	[UIView commitAnimations];
	}
}


@end
