//
//  CBorderView.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

- (void)dealloc
{
self.frameColor = NULL;
self.fillColor = NULL;
//
[super dealloc];
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
