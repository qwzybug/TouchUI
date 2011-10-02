//
//  UIImage_ThumbnailExtensions.m
//  TouchCode
//
//  Created by Ian Baird on 3/28/08.
//  Copyright 2011 Skorpiostech, Inc. All rights reserved.
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
//  or implied, of Skorpiostech, Inc..

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
