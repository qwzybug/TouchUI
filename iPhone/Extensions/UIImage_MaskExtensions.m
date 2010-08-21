//
//  UIImage_MaskExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/16/09.
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
