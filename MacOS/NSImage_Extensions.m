//
//  NSImage_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/29/08.
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

#import "NSImage_Extensions.h"


@implementation NSImage (NSImage_Extensions)

- (CGImageRef)CGImage
{
CGSize theImageSize = NSSizeToCGSize([self size]);

if (theImageSize.width <= 0.0 || theImageSize.height <= 0.0) [NSException raise:NSGenericException format:@"Cannot create CGImage from CIImage with zero extents"];

const size_t theRowBytes = theImageSize.width * 4;
const size_t theSize = theRowBytes * theImageSize.height;

NSMutableData *theData = [NSMutableData dataWithLength:theSize];
if (theData == NULL) [NSException raise:NSGenericException format:@"Could not create data."];

CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceRGB();
if (theColorSpace == NULL) [NSException raise:NSGenericException format:@"CGColorSpaceCreateDeviceRGB() failed."];

CGContextRef theBitmapContext = CGBitmapContextCreate([theData mutableBytes], theImageSize.width, theImageSize.height, 8, theRowBytes, theColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
if (theBitmapContext == NULL) [NSException raise:NSGenericException format:@"theBitmapContext() failed."];

[NSGraphicsContext saveGraphicsState];
[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:theBitmapContext flipped:NO]];

NSRect theFrame = { .origin = NSZeroPoint, .size = [self size] };
[self drawInRect:theFrame fromRect:theFrame operation:NSCompositeSourceOver fraction:1.0];
CFRelease(theBitmapContext);

[NSGraphicsContext restoreGraphicsState];


CGDataProviderRef theDataProvider = CGDataProviderCreateWithData(NULL, [theData mutableBytes], [theData length], NULL);
if (theDataProvider == NULL) [NSException raise:NSGenericException format:@"CGDataProviderCreateWithData() failed."];

CGImageRef theCGImage = CGImageCreate(theImageSize.width, theImageSize.height, 8, 32, theRowBytes, theColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst, theDataProvider, NULL, NO, kCGRenderingIntentDefault);
if (theCGImage == NULL) [NSException raise:NSGenericException format:@"CGImageCreate() failed."];

CFRelease(theDataProvider);

CFRelease(theColorSpace);

return(theCGImage);
}


@end
