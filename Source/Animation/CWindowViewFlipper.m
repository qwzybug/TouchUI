//
//  CWindowViewFlipper.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/30/08.
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

#import "CWindowViewFlipper.h"

@implementation CWindowViewFlipper

@synthesize viewOne;
@synthesize viewTwo;
@synthesize transition;
@synthesize animationDuration;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.transition = UIViewAnimationTransitionFlipFromLeft;
	self.animationDuration = 0.5f;
	}
return(self);
}


#pragma mark -

- (void)flipView:(UIView *)inViewOne toView:(UIView *)inViewTwo
{
self.viewOne = inViewOne;
self.viewTwo = inViewTwo;

[self flip];
}

- (void)flip
{
UIView *theSuperView = self.viewOne.superview;

[UIView beginAnimations:NULL context:NULL];
[UIView setAnimationDuration:animationDuration];
[UIView setAnimationTransition:self.transition forView:theSuperView cache:YES];

[self.viewOne removeFromSuperview];
[theSuperView addSubview:self.viewTwo];

[UIView commitAnimations];

UIView *theTemp = self.viewOne;
self.viewOne = self.viewTwo;
self.viewTwo = theTemp;

self.transition = (self.transition == UIViewAnimationTransitionFlipFromLeft ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft);
}

@end
