//
//  CBookmarkBarItemView.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/3/10.
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

#import "CBookmarkBarItemView.h"

#import "CBookmarkBar.h"
#import "CBookmarkBarItem.h"

@interface CBookmarkBarItemView ()
@end

#pragma mark -

@implementation CBookmarkBarItemView

@synthesize bookmarkBar;
@synthesize label;

+ (CBookmarkBarItemView *)bookmarkBarItemView
{
CBookmarkBarItemView *theItem = [self buttonWithType:UIButtonTypeCustom];
theItem.adjustsImageWhenHighlighted = NO;
theItem.adjustsImageWhenDisabled = NO;
theItem.showsTouchWhenHighlighted = YES;
return(theItem);
}

#pragma mark -

- (CBookmarkBarItem *)item
{
return(item);
}

- (void)setItem:(CBookmarkBarItem *)inItem
{
if (item != inItem)
	{
	item = inItem;

	[self setNeedsLayout];
	}
}

#pragma mark -
- (void)layoutSubviews
{
[super layoutSubviews];
//
if (self.label == NULL)
	{
	self.label = [[UILabel alloc] initWithFrame:self.bounds];
	self.label.backgroundColor = [UIColor clearColor];

	[self addSubview:self.label];
	}

self.label.text = self.item.title;
self.label.textColor = self.item.titleColor;
self.label.font = self.item.font;
}

- (void)sizeToFit
{
[super sizeToFit];
[self layoutIfNeeded];

CGFloat theSavedHeight = self.label.frame.size.height;
[self.label sizeToFit];
CGRect theFrame = self.label.frame;
theFrame.origin.x += self.bookmarkBar.gap3;
theFrame.size.height = theSavedHeight;
self.label.frame = theFrame;


theFrame = self.frame;
theFrame.size.width = self.label.bounds.size.width + self.bookmarkBar.gap3 * 2;
self.frame = theFrame;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
{
[super endTrackingWithTouch:touch withEvent:event];

SEL theAction = self.item.action;
id theTarget = self.item.target;
self.bookmarkBar.selectedItem = self.item;

if (theTarget && theAction && [theTarget respondsToSelector:theAction])
	{
	[theTarget performSelector:theAction withObject:self.item];
	}
}

- (void)update
{
[self setBackgroundImage:self.item.image forState:UIControlStateNormal];

[self layoutSubviews];
[self setNeedsDisplay];
}

@end
