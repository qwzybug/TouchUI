//
//  UIColor_Blending.m
//  TouchCode
//
//  Created by Christopher Liscio on 1/14/09.
//  Copyright 2009 SuperMegaUltraGroovy. All rights reserved.
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

#import "UIColor_Blending.h"

static unsigned int RED = 0;
static unsigned int GREEN = 1;
static unsigned int BLUE = 2;

#define HSB_MIX 0

@interface UIColor()
- (CGFloat)componentWithIndex:(unsigned int)inIndex;
@end

@implementation UIColor (Blending)

+ (id)blendedColorFromWeightingArray:(NSArray*)inArray;
{
    NSParameterAssert( inArray != nil );
    NSParameterAssert( [inArray count] > 0 );
    
#if (HSB_MIX)
    CGFloat finalHue = 0.;
    CGFloat finalSaturation = 0.;
    CGFloat finalBrightness = 0.;
    CGFloat finalAlpha = 0.;
    CGFloat finalWeight = 0.;
    
    for ( NSDictionary *d in inArray ) {
        UIColor *c = [d objectForKey:@"color"];
        NSNumber* weightNumber = [d objectForKey:@"weight"];
        CGFloat weight = [weightNumber doubleValue];
     
        finalHue += [c hueComponent] * weight;
        finalSaturation += [c saturationComponent] * weight;
        finalBrightness += [c brightnessComponent] * weight;
        finalAlpha += [c alphaComponent] * weight;
        
        finalWeight += weight;
    }
        
    return [UIColor 
        colorWithHue:finalHue / finalWeight
        saturation:finalSaturation / finalWeight
        brightness:finalBrightness / finalWeight
        alpha:finalAlpha / finalWeight];
#else
    CGFloat finalRed = 0.0f;
    CGFloat finalGreen = 0.0f;
    CGFloat finalBlue = 0.0f;
    CGFloat finalAlpha = 0.0f;
    CGFloat finalWeight = 0.0f;
        
    for ( NSDictionary *d in inArray ) {
        UIColor *c = [d objectForKey:@"color"];
        NSNumber* weightNumber = [d objectForKey:@"weight"];
        CGFloat weight = (CGFloat)[weightNumber doubleValue];
     
        finalRed += [c redComponent] * weight;
        finalGreen += [c greenComponent] * weight;
        finalBlue += [c blueComponent] * weight;
        finalAlpha += [c alphaComponent] * weight;
        
        finalWeight += weight;
    }
        
    return [UIColor 
        colorWithRed:finalRed / finalWeight
        green:finalGreen / finalWeight
        blue:finalBlue / finalWeight
        alpha:finalAlpha / finalWeight];
#endif
}

// Using math from the Wikipedia page:
//  http://en.wikipedia.org/wiki/HSL_color_space
- (CGFloat)hueComponent
{
    CGFloat red = [self redComponent];
    CGFloat green = [self greenComponent];
    CGFloat blue = [self blueComponent];
    
    CGFloat max = MAX( red, MAX( green, blue ) );
    CGFloat min = MIN( red, MIN( green, blue ) );
    
    CGFloat hue;
    
    if ( max == min ) {
        hue = 0.0f;
    }
    
    else if ( max == red ) {
        hue = ( 60.0f * ( ( green - blue ) / ( max - min ) ) );
        hue = (CGFloat)fmod( hue, 360.0f);
    }
    
    else if ( max == green ) {
        hue = ( 60.0f * ( ( blue - red ) / ( max - min ) ) + 120.0f );
    }
    
    else if ( max == blue ) {
        hue = ( 60.0f * ( ( red - green ) / ( max - min ) ) + 240.0f );
    }
    
    return hue / 360.0f;
}

- (CGFloat)saturationComponent
{
    CGFloat red = [self redComponent];
    CGFloat green = [self greenComponent];
    CGFloat blue = [self blueComponent];
    
    CGFloat max = MAX( red, MAX( green, blue ) );
    CGFloat min = MIN( red, MIN( green, blue ) );    
    
    if ( max == min ) {
        return 0;
    }
    
    CGFloat brightness = [self brightnessComponent];
    
    if ( brightness <= 0.5f ) {
        return ( max - min ) / ( max + min );
    }
    else {
        return ( max - min ) / ( 2.0f - ( max + min ) );
    }
}

- (CGFloat)brightnessComponent
{
    CGFloat red = [self redComponent];
    CGFloat green = [self greenComponent];
    CGFloat blue = [self blueComponent];
    
    CGFloat max = MAX( red, MAX( green, blue ) );
    CGFloat min = MIN( red, MIN( green, blue ) );    
    
    if ( max == 0 ) {
        return 0.0f;
    }
    
    return ( 1.0f - ( min / max ) );
}

- (CGFloat)redComponent
{
    return [self componentWithIndex:RED];
}

- (CGFloat)greenComponent
{
    return [self componentWithIndex:GREEN];
}

- (CGFloat)blueComponent
{
    return [self componentWithIndex:BLUE];
}

- (CGFloat)alphaComponent
{
    CGColorRef color = [self CGColor];
    return CGColorGetAlpha( color );
}

- (CGFloat)componentWithIndex:(unsigned int)inIndex
{
    CGColorRef color = [self CGColor];
    const CGFloat *components = CGColorGetComponents( color );
    const unsigned int count = CGColorGetNumberOfComponents( color );
    if ( inIndex >= count ) {
        return 0;
    }
    return components[inIndex];    
}

@end
