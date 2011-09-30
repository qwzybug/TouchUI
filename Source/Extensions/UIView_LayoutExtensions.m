//
//  UIView_LayoutExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
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
