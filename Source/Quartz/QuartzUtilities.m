//
//  QuartzUtilities.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/29/08.
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

#import "QuartzUtilities.h"

#if TARGET_OS_MAC
#elif TARGET_OS_IPHONE
#include <UIKit/UIKit.h>
#endif

CGImageRef CGImageCreateImageNamed(NSString *inName)
{
CGImageRef theImage = NULL;
#if TARGET_OS_IPHONE == 0
	NSBundle *theBundle = [NSBundle mainBundle];
	NSString *thePath = [theBundle pathForResource:[(NSString *)inName stringByDeletingPathExtension] ofType:[(NSString *)inName pathExtension]];
	NSURL *theURL = [NSURL fileURLWithPath:thePath];
	CGImageSourceRef theImageSource = CGImageSourceCreateWithURL((CFURLRef)theURL, NULL);
	theImage = CGImageSourceCreateImageAtIndex(theImageSource, 0, NULL);
	CFRelease(theImageSource);
#else
	UIImage *theUIKitImage = [UIImage imageNamed:inName];
	theImage = [theUIKitImage CGImage];
#endif
return(theImage);
}


void CGContextAddHorizontalLine(CGContextRef inContext, CGFloat X)
{
CGPoint theCurrentPoint = CGContextGetPathCurrentPoint(inContext);
CGContextAddLineToPoint(inContext, theCurrentPoint.x + X, theCurrentPoint.y);
}

void CGContextAddVerticalLine(CGContextRef inContext, CGFloat Y)
{
CGPoint theCurrentPoint = CGContextGetPathCurrentPoint(inContext);
CGContextAddLineToPoint(inContext, theCurrentPoint.x, theCurrentPoint.y + Y);
}

void CGContextAddRelativeLine(CGContextRef inContext, CGFloat X, CGFloat Y)
{
CGPoint theCurrentPoint = CGContextGetPathCurrentPoint(inContext);
CGContextAddLineToPoint(inContext, theCurrentPoint.x + X, theCurrentPoint.y + Y);
}

void CGContextAddRoundRectToPath(CGContextRef inContext, CGRect inBounds, CGFloat inTopLeftRadius, CGFloat inTopRightRadius, CGFloat inBottomLeftRadius, CGFloat inBottomRightRadius)
{
const CGFloat theMinX = CGRectGetMinX(inBounds);
const CGFloat theMaxX = CGRectGetMaxX(inBounds);
const CGFloat theMinY = CGRectGetMinY(inBounds);
const CGFloat theMaxY = CGRectGetMaxY(inBounds);

const CGFloat theTopLength = CGRectGetWidth(inBounds) - inTopLeftRadius - inTopRightRadius;
const CGFloat theLeftHeight = CGRectGetHeight(inBounds) - inTopLeftRadius - inBottomLeftRadius;
const CGFloat theBottomLength = CGRectGetWidth(inBounds) - inBottomLeftRadius - inBottomRightRadius;
const CGFloat theRightHeight = CGRectGetHeight(inBounds) - inTopRightRadius - inBottomRightRadius;

// TOP LEFT
CGContextMoveToPoint(inContext, theMinX + inTopLeftRadius, theMinY);

// DRAW TO TOP RIGHT
CGContextAddHorizontalLine(inContext, theTopLength);
CGContextAddCurveToPoint(inContext, theMaxX, theMinY, theMaxX, theMinY + inTopRightRadius, theMaxX, theMinY + inTopRightRadius);

// DRAW TO BOTTOM RIGHT
CGContextAddVerticalLine(inContext, theRightHeight);
CGContextAddCurveToPoint(inContext, theMaxX, theMaxY, theMaxX - inBottomRightRadius, theMaxY, theMaxX - inBottomRightRadius, theMaxY);

// DRAW TO BOTTOM LEFT
CGContextAddHorizontalLine(inContext, -theBottomLength);
CGContextAddCurveToPoint(inContext, theMinX, theMaxY, theMinX, theMaxY - inBottomLeftRadius, theMinX, theMaxY - inBottomLeftRadius);

// DRAW TO TOP LEFT
CGContextAddVerticalLine(inContext, -theLeftHeight);
CGContextAddCurveToPoint(inContext, theMinX, theMinY, theMinX + inTopLeftRadius, theMinY, theMinX + inTopLeftRadius, theMinY);
}

