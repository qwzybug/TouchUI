//
//  CLayoutView.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/12/09.
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

#import "CLayoutView.h"

#import "Geometry.h"

@implementation CLayoutView

@synthesize mode;
@synthesize gap;
@synthesize fitViews;
@synthesize flexibleView;

- (id)initWithFrame:(CGRect)frame
{
if ((self = [super initWithFrame:frame]) != NULL)
	{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	mode = LayoutMode_VerticalStack;
	gap = CGSizeMake(5, 5);
	fitViews = YES;
	flexibleView = nil;

	self.autoresizesSubviews = NO;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;

	#if DEBUG_RECT == 1
	self.contentMode = UIViewContentModeRedraw;
	#endif /* DEBUG_RECT == 1 */
	}
return(self);
}

- (id)initWithCoder:(NSCoder *)inDecoder
{
if ((self = [super initWithCoder:inDecoder]) != NULL)
	{
	mode = LayoutMode_VerticalStack;
	gap = CGSizeMake(5, 5);
	fitViews = YES;
	flexibleView = nil;

	self.autoresizesSubviews = NO;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
//	self.clipsToBounds = YES;

	#if DEBUG_RECT == 1
	self.contentMode = UIViewContentModeRedraw;
	#endif /* DEBUG_RECT == 1 */
	}
return(self);
}

- (void)setFrame:(CGRect)inFrame
{
[super setFrame:inFrame];
}

#if DEBUG_RECT == 1
- (void)drawRect:(CGRect)rect
{
[[UIColor yellowColor] set];
for (UIView *theView in self.subviews)
	{
	CGRect theFrame = theView.frame;
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), theFrame);
	}
}
#endif /* DEBUG_RECT == 1 */

- (CGSize)sizeThatFits:(CGSize)size
{
CGRect theUnionFrame = CGRectZero;

CGFloat N = 0.0f;
for (UIView *theView in self.subviews)
	{
	CGRect theFrame = theView.frame;

	if (mode == LayoutMode_VerticalStack)
		{
		theFrame.origin.y = N;
		N += theView.frame.size.height + self.gap.height;
		}
	else if (mode == LayoutMode_HorizontalStack)
		{
		theFrame.origin.x = N;
		N += theView.frame.size.width + self.gap.width;
		}

	theUnionFrame = CGRectUnion(theUnionFrame, theFrame);
	}

size = CGSizeMake(MIN(size.width, theUnionFrame.size.width), MIN(size.height, theUnionFrame.size.height));

return(size);
}

- (void)layoutSubviews
{
const CGFloat theMax = mode == LayoutMode_VerticalStack ? self.bounds.size.height : self.bounds.size.width;

CGFloat N = 0.0f;
	
	if (mode == LayoutMode_VerticalStack) {
		for (UIView *theView in self.subviews) {
		CGRect theFrame = theView.frame;
		theFrame.origin.y = N;

		if (self.fitViews) {
			theFrame.origin.x = 0;
			theFrame.size.width = self.bounds.size.width;
		}

		if (N < theMax && theFrame.origin.y + theFrame.size.height > theMax) {
			theFrame.size.height = theMax - theFrame.origin.y;
		}
			
		N += theView.frame.size.height + self.gap.height;
			theView.frame = theFrame;
		}
		
	} else if (mode == LayoutMode_HorizontalStack) {
		CGFloat flexibleWidth = 0.0f;
		if (flexibleView != nil) {
			NSMutableArray *views = [self.subviews mutableCopy];
			[views removeObject:flexibleView];
			CGFloat staticWidth = 0.0f;
			for (UIView *view in views) {
				staticWidth += view.frame.size.width + self.gap.width;
			}
			flexibleWidth = self.bounds.size.width - staticWidth;
		}
		for (UIView *theView in self.subviews) {
			CGRect theFrame = theView.frame;
			theFrame.origin.x = N;
			if (theView == flexibleView) {
				if (flexibleWidth < theFrame.size.width) {
					N += flexibleWidth + self.gap.width;
					theFrame.size.width = flexibleWidth;
				} else {
					N += theFrame.size.width + self.gap.width;
				}
			} else {
				N += theView.frame.size.width + self.gap.width;
			}
			theView.frame = theFrame;
		}
	}
}

- (void)addSubview:(UIView *)inSubview
{
[super addSubview:inSubview];
}

@end
