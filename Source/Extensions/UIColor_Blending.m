//
//  UIColor_Blending.m
//  TouchCode
//
//  Created by Christopher Liscio on 1/14/09.
//  Copyright 2011 SuperMegaUltraGroovy. All rights reserved.
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
//  or implied, of SuperMegaUltraGroovy.

#import "UIColor_Blending.h"

static unsigned int RED = 0;
static unsigned int GREEN = 1;
static unsigned int BLUE = 2;

#define HSB_MIX 0

@interface UIColor()
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
    
    CGFloat hue = 0.0f;
    
    if ( max == red ) {
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
    return [self _componentWithIndex:RED];
}

- (CGFloat)greenComponent
{
    return [self _componentWithIndex:GREEN];
}

- (CGFloat)blueComponent
{
    return [self _componentWithIndex:BLUE];
}

- (CGFloat)alphaComponent
{
    CGColorRef color = [self CGColor];
    return CGColorGetAlpha( color );
}

- (CGFloat)_componentWithIndex:(unsigned int)inIndex
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
