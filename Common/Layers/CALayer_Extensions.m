//
//  CALayer_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/24/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "CALayer_Extensions.h"

@implementation CALayer (CALayer_Extensions)

- (id)initWithFrame:(CGRect)inFrame
{
if ((self = [self init]) != NULL)
	{
	self.frame = inFrame;
	}
return(self);
}

#pragma mark -

- (CGFloat)zoom
{
const CATransform3D theTransform = self.transform;
if ((theTransform.m11 == theTransform.m22) && (theTransform.m22 == theTransform.m33))
	{
	return(theTransform.m11);
	}
else
	{
	return((theTransform.m11 + theTransform.m22 + theTransform.m33) / 3.0f);
	}
}

- (void)setZoom:(CGFloat)inZoom
{
CATransform3D theTransform = self.transform;
theTransform.m11 = theTransform.m22 = theTransform.m33 = inZoom;
self.transform = theTransform;
}

- (void)setZoom:(CGFloat)inZoom centeringAtPoint:(CGPoint)inPoint
{
CATransform3D theTransform = self.transform;

theTransform = CATransform3DTranslate(theTransform, inPoint.x, inPoint.y, 0.0f);

theTransform.m11 = theTransform.m22 = theTransform.m33 = inZoom;

theTransform = CATransform3DTranslate(theTransform, -inPoint.x, -inPoint.y, 0.0f);

self.transform = theTransform;
}

- (CAScrollLayer *)scrollLayer
{
CALayer *theLayer = self.superlayer;
while (theLayer && [theLayer isKindOfClass:[CAScrollLayer class]] == NO)
	{
	theLayer = theLayer.superlayer;
	}
return((CAScrollLayer *)theLayer);
}

@end
