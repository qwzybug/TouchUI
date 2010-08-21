//
//  UIImage_ThumbnailExtensions.m
//  TouchCode
//
//  Created by Ian Baird on 3/28/08.
//  Copyright 2008 Skorpiostech, Inc.. All rights reserved.
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

#import "UIImage_ThumbnailExtensions.h"


@implementation UIImage (UIImage_ThumbnailExtensions)

- (UIImage *)thumbnail:(CGSize)thumbSize cropped:(BOOL)cropped
{
    CGRect destRect = CGRectMake(0.0f, 0.0f, thumbSize.width, thumbSize.height);
    
	CGImageRef srcImage;
	
	if (!cropped) {
		if (self.size.width > self.size.height)
		{
			// Scale height down
			destRect.size.height = ceilf(self.size.height * (thumbSize.width / self.size.width));
			
			// Recenter
			destRect.origin.y = (thumbSize.height - destRect.size.height) / 2.0f;
		}
		else if (self.size.width < self.size.height)
		{
			// Scale width down
			destRect.size.width = ceilf(self.size.width * (thumbSize.height / self.size.height));
			
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
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL, thumbSize.width, thumbSize.height, 8, (4 * thumbSize.width), genericColorSpace, kCGImageAlphaPremultipliedFirst);
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

@end
