//
//  UIImage_Extensions.h
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

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Extensions)

#if DEBUG == 1
@property (readwrite, nonatomic, retain) NSString *debugName;
#endif /* DEBUG == 1 */

+ (UIImage *)imageWithContentsOfURL:(NSURL *)inURL;

+ (UIImage *)imageWithBackgroundImage:(UIImage *)inBackgroundImage foregroundImage:(UIImage *)inForegroundImage;

- (UIImage *)imageTintedWithColor:(UIColor *)inColor;

// #############################################################################

- (UIImage *)resizedImageToFit:(CGSize)inSize;

// #############################################################################

- (UIImage *)sizedImage:(CGSize)inSize;
- (UIImage *)mask;

// #############################################################################

- (UIImage *)thumbnail:(CGSize)thumbSize cropped:(BOOL)cropped;
- (UIImage *)thumbnail:(CGSize)thumbSize;

// #############################################################################

#if DEBUG == 1
- (NSString *)debugDescription;
#endif /* DEBUG == 1 */

+ (UIImage *)imageWithData:(NSData *)inData scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

+ (UIImage *)imageWithColor:(UIColor *)inColor;

+ (UIImage *)imageWithRoundRectByRoundingCorners:(UIRectCorner)inCorners cornerRadii:(CGSize)inCornerRadii fill:(UIColor *)inFill stroke:(UIColor *)inStroke;

+ (UIImage *)imageWithVerticalLinearGradient:(CGFloat)inHeight color0:(UIColor *)inColor0 color1:(UIColor *)inColor1;
+ (UIImage *)imageWithVerticalLinearGradient:(CGFloat)inHeight;

+ (UIImage *)imageWithSize:(CGSize)inSize opaque:(BOOL)inOpaque scale:(CGFloat)inScale block:(void (^)(CGContextRef))inBlock;

+ (UIImage *)imageWithText:(NSString *)inText withFont:(UIFont *)inFont;
+ (UIImage *)imageWithText:(NSString *)inText;

+ (UIImage *)imageWithPlaceholder;

- (UIImage *)imageScaledToSize:(CGSize)inSize opaque:(BOOL)inOpaque scale:(CGFloat)inScale;
- (UIImage *)imageScaledToSize:(CGSize)inSize opaque:(BOOL)inOpaque;
- (UIImage *)imageScaledToSize:(CGSize)inSize;

- (UIImage *)imageWithSubimage:(CGRect)inRect;

@end
