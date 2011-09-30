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


@implementation UIImage (UIImage_Extensions)

+ (UIImage *)imageWithContentsOfURL:(NSURL *)inURL
{
NSData *theData = [NSData dataWithContentsOfURL:inURL options:0 error:NULL];
return([self imageWithData:theData]);
}

+ (UIImage *)imageWithBackgroundImage:(UIImage *)inBackgroundImage foregroundImage:(UIImage *)inForegroundImage;
{
CGRect theFrame = CGRectMake(0, 0, inBackgroundImage.size.width, inBackgroundImage.size.height);
UIGraphicsBeginImageContext(theFrame.size);
[inBackgroundImage drawInRect:theFrame blendMode:kCGBlendModeNormal alpha:1.0];
[inForegroundImage drawInRect:theFrame blendMode:kCGBlendModeNormal alpha:1.0];
UIImage *theNewImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
return(theNewImage);
}

- (UIImage *)imageTintedWithColor:(UIColor *)inColor
{
CGRect theFrame = CGRectMake(0, 0, self.size.width, self.size.height);
UIGraphicsBeginImageContext(theFrame.size);
CGContextRef theContext = UIGraphicsGetCurrentContext();
CGContextSetFillColorWithColor(theContext, [inColor CGColor]);
CGContextFillRect(theContext, theFrame);
[self drawInRect:theFrame blendMode:kCGBlendModeDestinationIn alpha:1.0];
[self drawInRect:theFrame blendMode:kCGBlendModeMultiply alpha:1.0];
UIImage *theTintedImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
return(theTintedImage);
}

@end
