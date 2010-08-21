//
//  CBookmarkBarItemView.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/3/10.
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

- (void)dealloc
{
self.item = NULL;
self.label = NULL;
//
[super dealloc];
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
	[item autorelease];
	item = [inItem retain];

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
	self.label = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
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
NSLog(@"UPDATE: %@", self.item.image);

[self setBackgroundImage:self.item.image forState:UIControlStateNormal];

[self layoutSubviews];
[self setNeedsDisplay];
}

@end
