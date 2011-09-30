//
//  CBorderView.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
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

#import "CBorderView.h"

@implementation CBorderView

@synthesize frameInset;
@synthesize cornerRadius;
@synthesize frameWidth;
@synthesize frameColor;
@synthesize fillColor;

- (id)initWithFrame:(CGRect)frame
{
if ((self = [super initWithFrame:frame]) != NULL)
	{
	[self setup];
    }
return self;
}

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != NULL)
	{
	[self setup];
    }
return self;
}


- (void)drawRect:(CGRect)rect
{
CGContextRef theContext = UIGraphicsGetCurrentContext();

const CGFloat R = self.cornerRadius;

const CGRect theBounds = CGRectInset(self.bounds, self.frameInset, self.frameInset);
const CGFloat theMinX = CGRectGetMinX(theBounds);
const CGFloat theMaxX = CGRectGetMaxX(theBounds);
const CGFloat theMinY = CGRectGetMinY(theBounds);
const CGFloat theMaxY = CGRectGetMaxY(theBounds);

CGContextBeginPath(theContext);
CGContextMoveToPoint(theContext, theMinX + R, theMinY);

CGContextAddLineToPoint(theContext, theMaxX - R, theMinY);
CGContextAddCurveToPoint(theContext, theMaxX, theMinY, theMaxX, theMinY + R, theMaxX, theMinY + R);

CGContextAddLineToPoint(theContext, theMaxX, theMaxY - R);
CGContextAddCurveToPoint(theContext, theMaxX, theMaxY, theMaxX - R, theMaxY, theMaxX - R, theMaxY);

CGContextAddLineToPoint(theContext, theMinX + R, theMaxY);
CGContextAddCurveToPoint(theContext, theMinX, theMaxY, theMinX, theMaxY - R, theMinX, theMaxY - R);

CGContextAddLineToPoint(theContext, theMinX, theMinY + R);
CGContextAddCurveToPoint(theContext, theMinX, theMinY, theMinX + R, theMinY, theMinX + R, theMinY);

CGContextClosePath(theContext);

CGContextSetLineWidth(theContext, self.frameWidth);

CGContextSetStrokeColorWithColor(theContext, self.frameColor.CGColor);
CGContextSetFillColorWithColor(theContext, self.fillColor.CGColor);

CGContextDrawPath(theContext, kCGPathFillStroke);
}

- (void)setup
{
self.backgroundColor = [UIColor clearColor];
//
self.frameInset = 1.5f;
self.cornerRadius = 10.0f;
self.frameWidth = 1.5f;
self.frameColor = [UIColor lightGrayColor];
self.fillColor = [UIColor whiteColor];
}

- (CGSize)sizeThatFits:(CGSize)size
{
NSInteger theCount = self.subviews.count;
if (theCount == 0)
	{
	return(self.frame.size);
	}
else
	{
	CGRect theContentsFrame = CGRectZero;
	if (theCount == 1)
		{
		theContentsFrame = ((UIView *)[self.subviews lastObject]).frame;
		}
	else
		{
		theContentsFrame = CGRectZero;
		for (UIView *theView in self.subviews)
			{
			theContentsFrame = CGRectUnion(theContentsFrame, theView.frame);
			}
		}

	theContentsFrame = CGRectInset(theContentsFrame, - 5, - 5);

	theContentsFrame.size.width = MAX(theContentsFrame.size.width, self.cornerRadius + self.frameInset * 2);
	theContentsFrame.size.height = MAX(theContentsFrame.size.height, self.cornerRadius + self.frameInset * 2);

	theContentsFrame.size.width = MIN(theContentsFrame.size.width, size.width);

	return(theContentsFrame.size);
	}
}

- (void)sizeToFit
{
[super sizeToFit];

[self setNeedsLayout];
}

- (void)layoutSubviews
{
NSInteger theCount = self.subviews.count;
if (theCount == 1)
	{
	UIView *theChildView = [self.subviews lastObject];
	CGRect theBounds = self.bounds;
	theChildView.frame = CGRectInset(theBounds, 10, 10);
	}
else
	{
	// No clue what to do here. Layout in UIKit SUCKS.
	}

}

@end
