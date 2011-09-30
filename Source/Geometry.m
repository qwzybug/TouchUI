//
//  Geometry.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/15/2005.
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

#import "Geometry.h"

CGRect ScaleAndAlignRectToRect(CGRect inImageRect, CGRect inDestinationRect, EImageScaling inScaling, EImageAlignment inAlignment)
{
CGRect theScaledImageRect;

#if TARGET_OS_IPHONE == 0
#warning FIX THIS FOR NON IPHONE
#endif /* TARGET_OS_IPHONE == 0 */
BOOL flipped = YES;

if (inScaling == ImageScaling_ToFit)
	{
	theScaledImageRect.origin = inDestinationRect.origin;
	theScaledImageRect.size = inDestinationRect.size;
	}
else
	{
	CGSize theScaledImageSize = inImageRect.size;

	if (inScaling == ImageScaling_Proportionally)
		{
		float theScaleFactor = 1.0f;
		if (inDestinationRect.size.width / inImageRect.size.width < inDestinationRect.size.height / inImageRect.size.height)
			{
			theScaleFactor = inDestinationRect.size.width / inImageRect.size.width;
			}
		else
			{
			theScaleFactor = inDestinationRect.size.height / inImageRect.size.height;
			}
		theScaledImageSize.width *= theScaleFactor;
		theScaledImageSize.height *= theScaleFactor;

		theScaledImageRect.size = theScaledImageSize;
		}
	else if (inScaling == ImageScaling_None)
		{
		theScaledImageRect.size.width = theScaledImageSize.width;
		theScaledImageRect.size.height = theScaledImageSize.height;
		}
	//
	if (inAlignment == ImageAlignment_Center)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	else if (inAlignment == ImageAlignment_Top)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_TopLeft)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_TopRight)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + inDestinationRect.size.height - theScaledImageSize.height;
		}
	else if (inAlignment == ImageAlignment_Left)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	else if (inAlignment == ImageAlignment_Bottom)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + (inDestinationRect.size.width - theScaledImageSize.width) / 2.0f;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_BottomLeft)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_BottomRight)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y;
		}
	else if (inAlignment == ImageAlignment_Right)
		{
		theScaledImageRect.origin.x = inDestinationRect.origin.x + inDestinationRect.size.width - theScaledImageSize.width;
		theScaledImageRect.origin.y = inDestinationRect.origin.y + (inDestinationRect.size.height - theScaledImageSize.height) / 2.0f;
		}
	}

if (flipped == YES)
	{
	CGAffineTransform theTransform = CGAffineTransformMakeScale(1, -1);
	theTransform = CGAffineTransformTranslate(theTransform, 0, -inDestinationRect.size.height);

	theScaledImageRect = CGRectApplyAffineTransform(theScaledImageRect, theTransform);
	}

return(theScaledImageRect);
}

NSString *NSStringFromCIntegerPoint(CIntegerPoint inPoint)
{
return([NSString stringWithFormat:@"%d,%d", inPoint.x, inPoint.y]);
}

extern CIntegerPoint CIntegerPointFromString(NSString *inString)
{
NSScanner *theScanner = [NSScanner scannerWithString:inString];
CIntegerPoint thePoint;

BOOL theResult = [theScanner scanInteger:&thePoint.x];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];
theResult = [theScanner scanString:@"," intoString:NULL];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];
theResult = [theScanner scanInteger:&thePoint.y];
if (theResult == NO)
	[NSException raise:NSGenericException format:@"Could not scan CIntegerPoint"];

return(thePoint);
}


#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
NSString *NSStringFromCGAffineTransform(CGAffineTransform t)
{
return([NSString stringWithFormat:@"%g, %g, %g, %g, %g, %g", t.a, t.b, t.c, t.d, t.tx, t.ty]);
}
#endif /* defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE */
