//
//  UIImage_Resizing.m
//  TouchCode
//
//  Created by Devin Chalmers on 8/10/09.
//  Copyright 2009 Devin Chalmers. All rights reserved.
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

#import "UIImage_Resizing.h"

@implementation UIImage (UIImage_Resizing)

- (UIImage *)resizedImageToFit:(CGSize)inSize;
{
	if (self.size.width < inSize.width && self.size.height < inSize.height)
		return self;

		CGRect destRect = CGRectMake(0.0f, 0.0f, inSize.width, inSize.height);
	
	if (self.size.width > self.size.height)
	{
		// Scale height down
		destRect.size.height = ceilf(self.size.height * (inSize.width / self.size.width));
	}
	else if (self.size.width < self.size.height)
	{
		// Scale width down
		destRect.size.width = ceilf(self.size.width * (inSize.height / self.size.height));
	}
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, destRect.size.width, destRect.size.height, 8, (4 * destRect.size.width), colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
	
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    CGContextDrawImage(ctx, destRect, self.CGImage);
	
    CGImageRef resizedImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *result = [UIImage imageWithCGImage:resizedImage];
    CGImageRelease(resizedImage);
    
    return result;
}

@end
