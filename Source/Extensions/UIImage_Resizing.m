//
//  UIImage_Resizing.m
//  TouchCode
//
//  Created by Devin Chalmers on 8/10/09.
//  Copyright 2011 Devin Chalmers. All rights reserved.
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
//  or implied, of Devin Chalmers.

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
