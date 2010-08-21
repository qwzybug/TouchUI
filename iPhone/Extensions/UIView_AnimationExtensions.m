//
//  UIView_AnimationExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/9/09.
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
