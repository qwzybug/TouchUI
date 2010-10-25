//
//  UIColor_Blending.h
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

#import <Foundation/Foundation.h>


@interface UIColor (Blending)

// The passed-in array contains a set of NSDictionary objects laid out like so:
// 
//      { 'color':UIColor*, 'weight':NSNumber* },
//      { 'color':UIColor*, 'weight':NSNumber* },
//      ...
//
// A resulting color is determined by weighting the individual colors by their 
// weights as specified in the NSDictionary.
//
// The incoming weights should ideally add up to 1.  If not, the results are
// undefined.
+ (id)blendedColorFromWeightingArray:(NSArray*)inArray;

- (CGFloat)redComponent;
- (CGFloat)greenComponent;
- (CGFloat)blueComponent;
- (CGFloat)alphaComponent;

- (CGFloat)hueComponent;
- (CGFloat)saturationComponent;
- (CGFloat)brightnessComponent;

@end
