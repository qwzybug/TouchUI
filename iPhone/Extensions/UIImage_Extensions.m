//
//  UIImage_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/27/09.
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
