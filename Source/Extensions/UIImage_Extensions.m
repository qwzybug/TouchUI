//
//  UIImage_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/27/09.
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

#import "UIImage_Extensions.h"

#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>

#include <tgmath.h>

@implementation UIImage (UIImage_Extensions)

+ (UIImage *)imageWithContentsOfURL:(NSURL *)inURL
    {
    NSData *theData = [NSData dataWithContentsOfURL:inURL options:0 error:NULL];
    return([self imageWithData:theData]);
    }

+ (UIImage *)imageWithBackgroundImage:(UIImage *)inBackgroundImage foregroundImage:(UIImage *)inForegroundImage;
    {
    CGRect theFrame = CGRectMake(0, 0, inBackgroundImage.size.width, inBackgroundImage.size.height);
    UIGraphicsBeginImageContextWithOptions(theFrame.size, NO, 0.0);
    [inBackgroundImage drawInRect:theFrame blendMode:kCGBlendModeNormal alpha:1.0];
    [inForegroundImage drawInRect:theFrame blendMode:kCGBlendModeNormal alpha:1.0];
    UIImage *theNewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return(theNewImage);
    }

- (UIImage *)imageTintedWithColor:(UIColor *)inColor
    {
    CGRect theFrame = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(theFrame.size, NO, 0.0);
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(theContext, [inColor CGColor]);
    CGContextFillRect(theContext, theFrame);
    [self drawInRect:theFrame blendMode:kCGBlendModeDestinationIn alpha:1.0];
    [self drawInRect:theFrame blendMode:kCGBlendModeMultiply alpha:1.0];
    UIImage *theTintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return(theTintedImage);
    }

// #############################################################################

#if DEBUG == 1
static void *kDebugNameKey = NULL;

- (NSString *)debugName 
    {
    return(objc_getAssociatedObject(self, &kDebugNameKey));
    }
    
- (void)setDebugName:(NSString *)inDebugName
    {
    objc_setAssociatedObject(self, &kDebugNameKey, inDebugName, OBJC_ASSOCIATION_RETAIN);
    }
#endif /* DEBUG == 1 */


- (UIImage *)resizedImageToFit:(CGSize)inSize;
{
	if (self.size.width < inSize.width && self.size.height < inSize.height)
		return self;

		CGRect destRect = CGRectMake(0.0f, 0.0f, inSize.width, inSize.height);
	
	if (self.size.width > self.size.height)
	{
		// Scale height down
		destRect.size.height = ceil(self.size.height * (inSize.width / self.size.width));
	}
	else if (self.size.width < self.size.height)
	{
		// Scale width down
		destRect.size.width = ceil(self.size.width * (inSize.height / self.size.height));
	}
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, (size_t)destRect.size.width, (size_t)destRect.size.height, 8, (size_t)(4 * destRect.size.width), colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
	
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    CGContextDrawImage(ctx, destRect, self.CGImage);
	
    CGImageRef resizedImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *result = [UIImage imageWithCGImage:resizedImage];
    CGImageRelease(resizedImage);
    
    return result;
}

// #############################################################################

- (UIImage *)sizedImage:(CGSize)inSize
    {
    CGImageRef theImage = NULL;
    //theImage = self.CGImage;
    CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceGray();
    size_t theComponentCount = CGColorSpaceGetNumberOfComponents(theColorSpace);
    size_t theBitsPerComponent = 8; // CGImageGetBitsPerComponent(theImage);
    size_t theWidth = (size_t)ceil(inSize.width);
    size_t theHeight = (size_t)ceil(inSize.height);
    size_t theBytesPerRow = theWidth * (theBitsPerComponent * theComponentCount) / 8;
    size_t theLength = theHeight * theBytesPerRow;
    NSMutableData *theData = [NSMutableData dataWithLength:theLength];
    CGContextRef theBitmapContext = CGBitmapContextCreate(theData.mutableBytes, theWidth, theHeight, theBitsPerComponent, theBytesPerRow, theColorSpace, kCGImageAlphaNone);

    CGRect theBounds = { .origin = CGPointZero, .size = inSize };

    UIGraphicsPushContext(theBitmapContext);
    [self drawInRect:theBounds];
    UIGraphicsPopContext();

    theImage = CGBitmapContextCreateImage(theBitmapContext);
    CGContextRelease(theBitmapContext);
    if (theColorSpace)
    CFRelease(theColorSpace);

    UIImage *theNewImage = [UIImage imageWithCGImage:theImage];

    CFRelease(theImage);

    return(theNewImage);
    }

- (UIImage *)mask
    {
    CGImageRef theImage = self.CGImage;
    CGImageRef theMask = CGImageMaskCreate(CGImageGetWidth(theImage), CGImageGetHeight(theImage), CGImageGetBitsPerComponent(theImage), CGImageGetBitsPerPixel(theImage), CGImageGetBytesPerRow(theImage), CGImageGetDataProvider(theImage), NULL, YES);

    UIImage *theMaskImage = [UIImage imageWithCGImage:theMask];
    
    CFRelease(theMask);

    return(theMaskImage);
    }

// #############################################################################

- (UIImage *)thumbnail:(CGSize)thumbSize cropped:(BOOL)cropped
{
    CGRect destRect = CGRectMake(0.0f, 0.0f, thumbSize.width, thumbSize.height);

	CGImageRef srcImage;

	if (!cropped) {
		if (self.size.width > self.size.height)
		{
			// Scale height down
			destRect.size.height = ceil(self.size.height * (thumbSize.width / self.size.width));

			// Recenter
			destRect.origin.y = (thumbSize.height - destRect.size.height) / 2.0f;
		}
		else if (self.size.width < self.size.height)
		{
			// Scale width down
			destRect.size.width = ceil(self.size.width * (thumbSize.height / self.size.height));

			// Recenter
			destRect.origin.x = (thumbSize.width - destRect.size.width) / 2.0f;
		}

		srcImage = self.CGImage;
	} else {
		// crop source image to a square
		float croppedSize = MIN(self.size.width, self.size.height);

		CGRect srcRect = CGRectMake((self.size.width - croppedSize) / 2,
									(self.size.height - croppedSize) / 2,
									croppedSize, croppedSize);

		srcImage = CGImageCreateWithImageInRect(self.CGImage, srcRect);
	}

    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL, (size_t)thumbSize.width, (size_t)thumbSize.height, 8, (size_t)(4 * thumbSize.width), genericColorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationHigh);
    CGContextDrawImage(thumbBitmapCtxt, destRect, srcImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);

    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];

    CGImageRelease(tmpThumbImage);

	if (cropped)
		CGImageRelease(srcImage);

    return result;
}

- (UIImage *)thumbnail:(CGSize)thumbSize
{
	return [self thumbnail:thumbSize cropped:NO];
}

// #############################################################################

+ (UIImage *)imageWithData:(NSData *)inData scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
    {
    if (scale == 0.0)
        {
        scale = [UIScreen mainScreen].scale;
        }
    
    UIImage *theImage = NULL;
    CGImageSourceRef theImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)inData, NULL);
    if (theImageSource != NULL)
        {
        CGImageRef theCGImage = CGImageSourceCreateImageAtIndex(theImageSource, 0, NULL);
        if (theCGImage != NULL)
            {
            theImage = [UIImage imageWithCGImage:theCGImage scale:scale orientation:orientation];
            CFRelease(theCGImage);
            }
        CFRelease(theImageSource);
        }
    return(theImage);
    }

+ (UIImage *)imageWithColor:(UIColor *)inColor
    {
    CGFloat theAlpha;
    BOOL theFlag = [inColor getRed:NULL green:NULL blue:NULL alpha:&theAlpha];
    if (theFlag == NO)
        {
        theFlag = [inColor getWhite:NULL alpha:&theAlpha];
        if (theFlag == NO)
            {
            return(NULL);
            }
        }

    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, theAlpha != 1.0, 1.0);

    [inColor set];

    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGContextFillRect(theContext, (CGRect){ .size = { 1, 1 } });

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();

    theImage = [theImage resizableImageWithCapInsets:(UIEdgeInsets){ }];

    UIGraphicsEndImageContext();
    return(theImage);
    }

+ (UIImage *)imageWithRoundRectByRoundingCorners:(UIRectCorner)inCorners cornerRadii:(CGSize)inCornerRadii fill:(UIColor *)inFill stroke:(UIColor *)inStroke;
    {
    CGFloat kLineWidth = 1.0;

    if (inStroke == NULL)
        {
        inStroke = inFill;
        }

    CGRect theRect = { .size = { .width = inCornerRadii.width * 2 + 1 + kLineWidth * 2, .height = inCornerRadii.height * 2 + 1 + kLineWidth * 2 } };

    UIGraphicsBeginImageContextWithOptions(theRect.size, NO, 0.0);

    theRect = CGRectInset(theRect, 1, 1);

    [inFill setFill];
    [inStroke setStroke];

    UIBezierPath *thePath = [UIBezierPath bezierPathWithRoundedRect:theRect byRoundingCorners:inCorners cornerRadii:inCornerRadii];
    thePath.lineWidth = kLineWidth;
    if (inFill)
        {
        [thePath fill];
        }

    if (inStroke)
        {
        [thePath stroke];
        }

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();

    theImage = [theImage resizableImageWithCapInsets:(UIEdgeInsets){ .top = inCornerRadii.height + 1, .left = inCornerRadii.width + 1, .bottom = inCornerRadii.height + 1, .right = inCornerRadii.width + 1 }];

    UIGraphicsEndImageContext();

    return(theImage);
    }

+ (UIImage *)imageWithVerticalLinearGradient:(CGFloat)inHeight color0:(UIColor *)inColor0 color1:(UIColor *)inColor1;
    {
    CGRect theRect = { .size = { .width = 1.0, .height = inHeight } };

    // TODO:set opaque flag properly
    UIGraphicsBeginImageContextWithOptions(theRect.size, NO, 0.0);

    NSArray *theColors = [NSArray arrayWithObjects:
        (__bridge id)inColor0.CGColor,
        (__bridge id)inColor1.CGColor,
        NULL];

    CGFloat theLocations[] = { 0.0, 1.0 };

    CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceRGB();

    CGGradientRef theGradient = CGGradientCreateWithColors(theColorSpace, (__bridge CFArrayRef)theColors, theLocations);

    CGContextRef theContext = UIGraphicsGetCurrentContext();

    CGContextDrawLinearGradient(theContext, theGradient, (CGPoint){ .x = 0.0, .y = 0.0 }, (CGPoint){ .x = 0.0, .y = inHeight }, 0);

    CFRelease(theGradient);
    CFRelease(theColorSpace);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();

    theImage = [theImage resizableImageWithCapInsets:(UIEdgeInsets){ }];

    UIGraphicsEndImageContext();

    return(theImage);
    }

+ (UIImage *)imageWithVerticalLinearGradient:(CGFloat)inHeight
    {
    return([self imageWithVerticalLinearGradient:inHeight color0:[UIColor blackColor] color1:[UIColor whiteColor]]);
    }

+ (UIImage *)imageWithSize:(CGSize)inSize opaque:(BOOL)inOpaque scale:(CGFloat)inScale block:(void (^)(CGContextRef))inBlock;
    {
    UIGraphicsBeginImageContextWithOptions(inSize, inOpaque, inScale);

    CGContextRef theContext = UIGraphicsGetCurrentContext();

    inBlock(theContext);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return(theImage);
    }

+ (UIImage *)imageWithText:(NSString *)inText withFont:(UIFont *)inFont
    {
    CGSize theSize = [inText sizeWithFont:inFont];

    return([self imageWithSize:theSize opaque:NO scale:0.0 block:^(CGContextRef inContext) {
        [inText drawAtPoint:CGPointZero withFont:inFont];
        }]);
    }


+ (UIImage *)imageWithText:(NSString *)inText;
    {
    UIFont *theFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    return([self imageWithText:inText withFont:theFont]);
    }

+ (UIImage *)imageWithPlaceholder
    {
    return([UIImage imageWithText:@"💩"]);
    }

#pragma mark -

#if DEBUG == 1

- (NSString *)debugDescription
    {
    return([NSString stringWithFormat:@"%@ (%@)", [self description], NSStringFromCGSize(self.size)]);
    }

#endif /* DEBUG == 1 */

- (UIImage *)imageScaledToSize:(CGSize)inSize opaque:(BOOL)inOpaque scale:(CGFloat)inScale
    {
    // TODO: what about UIImage.scale? (i.e. retina display)

    UIGraphicsBeginImageContextWithOptions(inSize, inOpaque, inScale);
    [self drawInRect:(CGRect){ .size = inSize }];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return(theImage);
    }

- (UIImage *)imageScaledToSize:(CGSize)inSize opaque:(BOOL)inOpaque
    {
    return([self imageScaledToSize:inSize opaque:inOpaque scale:self.scale]);
    }

- (UIImage *)imageScaledToSize:(CGSize)inSize
    {
    return([self imageScaledToSize:inSize opaque:NO scale:self.scale]);
    }

- (UIImage *)imageWithSubimage:(CGRect)inRect
    {
    UIGraphicsBeginImageContextWithOptions(inRect.size, NO, self.scale);

    [self drawAtPoint:(CGPoint){ .x = -inRect.origin.x, .y = -inRect.origin.y }];

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return(theImage);
    }


@end
