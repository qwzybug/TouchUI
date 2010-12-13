//
//  UIView_LayoutExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
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

#import "UIView_LayoutExtensions.h"

@implementation UIView (UIView_LayoutExtensions)

- (void)sizeToFit:(CGSize)inSize;
{
CGSize theSize = [self sizeThatFits:inSize];
// TODO: understand why its not making this large enough to show all the text
theSize.width += 10;
theSize.width = MIN(theSize.width, inSize.width);
CGRect theFrame = self.frame;
theFrame.size = theSize;
self.frame = theFrame;
}

- (void)layoutSubviewsUsingMethod:(ELayoutMethod)inMethod
{
switch (inMethod)
	{
	case LayoutMethod_MakeColumn:
		{
		CGFloat theMaxY = 0;

		for (UIView *theSubview in self.subviews)
			{
			if (theSubview.hidden == YES)
				{
				continue;
				}
			CGRect theFrame = theSubview.frame;
			theFrame.origin.y = theMaxY;
			theSubview.frame = theFrame;

			theMaxY = CGRectGetMaxY(theSubview.frame);
			}
		}
		break;
	default:
		break;
	}
}

- (void)adjustFrameToFramesOfSubviews
{
CGRect theRect = CGRectZero;

for (UIView *theView in self.subviews)
	{
	if (theView.hidden == YES)
		{
		continue;
		}
	theRect = CGRectUnion(theRect, theView.frame);
	}

self.frame = theRect;
}

- (void)dumpViewTree
{
[self dumpViewTree:0 maxDepth:2];
}

- (void)dumpViewTree:(int)inCurrentDepth maxDepth:(int)inMaxDepth;
{
if (inCurrentDepth >= inMaxDepth)
	return;
char theSpaces[] = "                                                                                                                                ";
theSpaces[inCurrentDepth] = '\0';
for (UIView *theView in self.subviews)
	{
	[theView dumpViewTree:inCurrentDepth + 1 maxDepth:inMaxDepth];
	}
}

@end
