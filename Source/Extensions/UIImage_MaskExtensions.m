//
//  UIImage_MaskExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/16/09.
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

#import "UIImage_MaskExtensions.h"


@implementation UIImage (UIImage_MaskExtensions)

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

- (CGImageRef)mask
{
CGImageRef theImage = self.CGImage;
CGImageRef theMask = CGImageMaskCreate(CGImageGetWidth(theImage), CGImageGetHeight(theImage), CGImageGetBitsPerComponent(theImage), CGImageGetBitsPerPixel(theImage), CGImageGetBytesPerRow(theImage), CGImageGetDataProvider(theImage), NULL, YES);

[(id)theMask autorelease];

return(theMask);
}

@end
