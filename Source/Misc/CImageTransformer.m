//
//  CImageTransformer.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/10/11.
//  Copyright 2011 Jonathan Wight. All rights reserved.
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
//  or implied, of 2011 Jonathan Wight.

#import "CImageTransformer.h"

#import "UIImage_Extensions.h"

@implementation CImageTransformer

@synthesize identifier;

+ (Class)transformedValueClass
    {
    return([UIImage class]);
    }

+ (BOOL)allowsReverseTransformation
    {
    return(NO);
    }

#pragma mark -

- (void)encodeWithCoder:(NSCoder *)aCoder
    {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    }

- (id)initWithCoder:(NSCoder *)aDecoder
    {
    if ((self = [super init]) != NULL)
        {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        }
    return self;
    }

@end

#pragma mark -

@implementation CBlockBasedImageTransformer : CImageTransformer

@synthesize block;

- (id)initWithBlock:(UIImage * (^)(UIImage *))inBlock
    {
    if ((self = [super init]) != NULL)
        {
        block = inBlock;
        }
    return self;
    }

- (UIImage *)transformedValue:(UIImage *)inImage
    {
    return(self.block(inImage));
    }

@end


#pragma mark -

@implementation CMultiImageTransformer : CImageTransformer

@synthesize transformers;

- (UIImage *)transformedValue:(UIImage *)inImage
    {
    UIImage *theImage = inImage;
    for (CImageTransformer *theTransformer in self.transformers)
        {
        theImage = [theTransformer transformedValue:theImage];
        }
    return(theImage);
    }

#pragma mark -

- (void)encodeWithCoder:(NSCoder *)aCoder
    {
    [super encodeWithCoder:aCoder];
    //
    [aCoder encodeObject:self.transformers forKey:@"transformers"];
    }

- (id)initWithCoder:(NSCoder *)aDecoder
    {
    if ((self = [super initWithCoder:aDecoder]) != NULL)
        {
        transformers = [aDecoder decodeObjectForKey:@"transformers"];
        }
    return self;
    }

@end

#pragma mark -

@implementation CResizeImageTransformer

@synthesize size;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        size = (CGSize){ 128, 128 };
        }
    return self;
    }

- (UIImage *)transformedValue:(UIImage *)inImage
    {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, inImage.scale);
    [inImage drawInRect:(CGRect){ .size = self.size }];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return(theImage);
    }

#pragma mark -

- (void)encodeWithCoder:(NSCoder *)aCoder
    {
    [super encodeWithCoder:aCoder];
    //
    [aCoder encodeCGSize:self.size forKey:@"size"];
    }

- (id)initWithCoder:(NSCoder *)aDecoder
    {
    if ((self = [super initWithCoder:aDecoder]) != NULL)
        {
        size = [aDecoder decodeCGSizeForKey:@"size"];
        }
    return self;
    }

@end

#pragma mark -

@implementation CBorderedImageTransformer

@synthesize strokeColor;
@synthesize fillColor;

+ (NSArray *)parameterNames
    {
    return([NSArray arrayWithObjects:@"fillColor", NULL]);
    }

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        strokeColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        fillColor = [UIColor greenColor];
        }
    return self;
    }

- (UIImage *)transformedValue:(UIImage *)inImage
    {
    const CGFloat kBorderWidth = 2;
    const CGFloat kCornerRadius = 5;

    const CGSize theImageSize = inImage.size;
    CGSize theOutputImageSize = theImageSize;
    theOutputImageSize.width += kBorderWidth * 2;
    theOutputImageSize.height += kBorderWidth * 2;

    UIGraphicsBeginImageContextWithOptions(theOutputImageSize, NO, inImage.scale);

    UIImage *theImage = [UIImage imageWithSize:theOutputImageSize opaque:NO scale:inImage.scale block:^(CGContextRef inContext) {
        CGContextSaveGState(inContext);

        CGRect theOuterRect = (CGRect){ .size = theOutputImageSize };

        UIBezierPath *theOuterPath = [UIBezierPath bezierPathWithRoundedRect:theOuterRect cornerRadius:kCornerRadius];
        [theOuterPath addClip];

        [self.fillColor set];
        CGContextFillRect(inContext, (CGRect){ .size = theOutputImageSize });

        CGContextRestoreGState(inContext);

        //

        CGContextSaveGState(inContext);
        CGRect theInnerRect = CGRectInset(theOuterRect, kBorderWidth, kBorderWidth);

        UIBezierPath *theInnerPath = [UIBezierPath bezierPathWithRoundedRect:theInnerRect cornerRadius:kCornerRadius];
        [theInnerPath addClip];

        [inImage drawInRect:theInnerRect];

        CGContextRestoreGState(inContext);

        //

        [self.strokeColor set];
        [theOuterPath stroke];
        }];


    return(theImage);
    }

#pragma mark -

- (void)encodeWithCoder:(NSCoder *)aCoder
    {
    [super encodeWithCoder:aCoder];
    //
    [aCoder encodeObject:self.fillColor forKey:@"fillColor"];
    [aCoder encodeObject:self.strokeColor forKey:@"strokeColor"];
    [aCoder encodeInteger:1 forKey:@"version"];
    }

- (id)initWithCoder:(NSCoder *)aDecoder
    {
    if ((self = [super initWithCoder:aDecoder]) != NULL)
        {
        fillColor = [aDecoder decodeObjectForKey:@"fillColor"];
        strokeColor = [aDecoder decodeObjectForKey:@"strokeColor"];
        }
    return self;
    }

@end
