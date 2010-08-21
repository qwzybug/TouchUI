//
//  CAScrollLayer_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/14/08.
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

#import "CAScrollLayer_Extensions.h"

@implementation CAScrollLayer (CAScrollLayer_Extensions)

- (void)scrollBy:(CGPoint)inDelta
{
const CGRect theVisibleRect = self.visibleRect;
const CGPoint theNewScrollLocation = { .x = CGRectGetMinX(theVisibleRect) + inDelta.x, .y = CGRectGetMinY(theVisibleRect) + inDelta.y };
[self scrollToPoint:theNewScrollLocation];
}

- (void)scrollCenterToPoint:(CGPoint)inPoint;
{
const CGRect theBounds = self.bounds;
const CGPoint theCenter = { 
	.x = CGRectGetMidX(theBounds),
	.y = CGRectGetMidY(theBounds),
	};
const CGPoint theNewPoint = {
	.x = inPoint.x - theCenter.x,
	.y = inPoint.y - theCenter.y,
	};

[self scrollToPoint:theNewPoint];
}

@end
