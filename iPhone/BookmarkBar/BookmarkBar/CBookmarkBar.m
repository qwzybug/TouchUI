//
//  CBookmarkBar.m
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

#import "CBookmarkBar.h"

#import "CBookmarkBarItemView.h"
#import "CBookmarkBarItem.h"

@interface CBookmarkBar ()
@property (readwrite, nonatomic, retain) UIScrollView *scrollView;

- (CBookmarkBarItemView *)viewForItem:(CBookmarkBarItem *)inItem;
- (void)setDefaults;
@end

#pragma mark -

@implementation CBookmarkBar

@synthesize defaultItemAttributes;
@synthesize selectedItemAttributes;
@synthesize gap1;
@synthesize gap2;
@synthesize gap3;
@synthesize bottomBorderHeight;
@synthesize scrollView;

- (id)initWithFrame:(CGRect)inFrame
{
if ((self = [super initWithFrame:inFrame]) != NULL)
	{
	[self setDefaults];

	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];

	[self setNeedsLayout];
	}
return(self);
}

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != NULL)
	{
	[self setDefaults];

	[self setNeedsLayout];
	}
return(self);
}

- (void)dealloc
{
self.items = NULL;
self.selectedItem = NULL;
self.defaultItemAttributes = NULL;
self.selectedItemAttributes = NULL;
self.scrollView = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSArray *)items
{
return(items);
}

- (void)setItems:(NSArray *)inItems
{
if (items != inItems)
	{
	if (items != NULL)
		{
		for (CBookmarkBarItem *theItem in items)
			theItem.bookmarkBar = NULL;
		//
		[items autorelease];
		items = NULL;
		//
		[self.scrollView removeFromSuperview];
		self.scrollView = NULL;
		}

	if (inItems != NULL)
		{
		items = [inItems retain];
		for (CBookmarkBarItem *theItem in items)
			{
			theItem.bookmarkBar = self;
			for (NSString *theKey in self.defaultItemAttributes)
				{
				[theItem setValue:[self.defaultItemAttributes objectForKey:theKey] forKey:theKey];
				}
			}
		//
		if ([items containsObject:self.selectedItem] == NO)
			self.selectedItem = NULL;

		[self.scrollView removeFromSuperview];
		self.scrollView = NULL;

		[self layoutSubviews];
		}
	}
}

- (CBookmarkBarItem *)selectedItem
{
return(selectedItem);
}

- (void)setSelectedItem:(CBookmarkBarItem *)inSelectedItem
{
if (selectedItem != inSelectedItem)
	{
	if (self.selectedItem)
		{
		self.selectedItem.selected = NO;

		for (NSString *theKey in self.defaultItemAttributes)
			{
			[self.selectedItem setValue:[self.defaultItemAttributes objectForKey:theKey] forKey:theKey];
			}

		CBookmarkBarItemView *theView = [self viewForItem:self.selectedItem];
		[theView update];
		}

	selectedItem = inSelectedItem;

	if (self.selectedItem)
		{
		self.selectedItem.selected = YES;

		for (NSString *theKey in self.selectedItemAttributes)
			{
			[self.selectedItem setValue:[self.selectedItemAttributes objectForKey:theKey] forKey:theKey];
			}

		CBookmarkBarItemView *theView = [self viewForItem:self.selectedItem];
		[theView update];

		const CGRect theItemFrame = theView.frame;
		const CGRect theBounds = self.bounds;
		const CGRect theScrollRect = {
			.origin = { .x = CGRectGetMidX(theItemFrame) - CGRectGetMidX(theBounds), .y = CGRectGetMidY(theItemFrame) - CGRectGetMidY(theBounds) },
			.size = theBounds.size
			};

		[self.scrollView scrollRectToVisible:theScrollRect animated:YES];
		}
	}
}

#pragma mark -

//- (void)drawRect:(CGRect)rect
//{
//NSLog(@"DRAWRECT");
//
////[CThemeManager instance].tableSeparatorColor
//
//CGContextRef theContext = UIGraphicsGetCurrentContext();
//
//CGContextSetStrokeColorWithColor(theContext, [UIColor redColor].CGColor);
//
//CGContextSetLineWidth(theContext, 2.0);
//CGContextMoveToPoint(theContext, 0, CGRectGetMaxY(self.bounds));
//CGContextAddLineToPoint(theContext, self.bounds.size.width, CGRectGetMaxY(self.bounds));
//CGContextStrokePath(theContext);
//}
//
- (void)layoutSubviews
{
if (self.scrollView == NULL)
	{
	CGRect theScrollViewFrame = self.bounds;
//	theScrollViewFrame.origin.y += self.bottomBorderHeight;
//	theScrollViewFrame.size.height -= self.bottomBorderHeight;

	self.scrollView = [[[UIScrollView alloc] initWithFrame:theScrollViewFrame] autorelease];

	self.scrollView.directionalLockEnabled = YES;
	self.scrollView.bounces = YES;
	self.scrollView.alwaysBounceVertical = NO;
	self.scrollView.alwaysBounceHorizontal = NO;
	self.scrollView.pagingEnabled = NO;
	self.scrollView.scrollEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;

	CGSize theSize = self.scrollView.bounds.size;

	CGRect theFrame = { .origin = { .x = self.gap1, .y = 0.0 }, .size = theSize };
	CGRect theScrollFrame = CGRectZero;
	for (CBookmarkBarItem *theBookmarkItem in self.items)
		{
//		CBookmarkBarItemView *theBookmarkItemView = [[[CBookmarkBarItemView alloc] initWithFrame:theFrame] autorelease];
//		theBookmarkItemView.bookmarkBar = self;
//		theBookmarkItemView.item = theBookmarkItem;
//		[theBookmarkItemView sizeToFit];
//
//		[self.scrollView addSubview:theBookmarkItemView];
//
//		theFrame.origin.x += theBookmarkItemView.frame.size.width + self.gap2;
//		theScrollFrame = CGRectUnion(theScrollFrame, theBookmarkItemView.frame);
		CGFloat theNewX = CGRectGetMaxX(theScrollFrame) + self.gap2;

		CBookmarkBarItemView *theView = theBookmarkItem.view;
		if (theView == NULL)
			{
			theView = [self newViewForItem:theBookmarkItem];

			CGRect theFrame = theView.frame;

			theFrame.origin.x = theNewX;
			theView.frame = theFrame;

			theScrollFrame = CGRectUnion(theScrollFrame, theFrame);

			[self.scrollView addSubview:theView];
			}

		}

	theScrollFrame.size.width += self.gap1;
	self.scrollView.contentSize = theScrollFrame.size;

	[self addSubview:self.scrollView];
	}
}

#pragma mark -

- (CBookmarkBarItemView *)newViewForItem:(CBookmarkBarItem *)inItem
{
CGRect theFrame = { .origin = CGPointZero, .size = self.scrollView.bounds.size };

UIImage *theImage = [self.defaultItemAttributes objectForKey:@"image"];

CBookmarkBarItemView *theBookmarkItemView = [CBookmarkBarItemView bookmarkBarItemView];
[theBookmarkItemView setBackgroundImage:theImage forState:UIControlStateNormal];

theBookmarkItemView.frame = theFrame;
theBookmarkItemView.bookmarkBar = self;
theBookmarkItemView.item = inItem;
[theBookmarkItemView sizeToFit];
inItem.view = theBookmarkItemView;

return(theBookmarkItemView);
}

#pragma mark -

- (CBookmarkBarItemView *)viewForItem:(CBookmarkBarItem *)inItem;
{
NSInteger theIndex = [self.items indexOfObject:inItem];
if (theIndex != NSNotFound)
	{
	CBookmarkBarItemView *theItemView = [self.scrollView.subviews objectAtIndex:theIndex];
	return(theItemView);
	}
else
	return(NULL);
}

- (void)setDefaults
{
UIImage *theUnselectedImage = [[UIImage imageNamed:@"TabUnselected.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
UIImage *theSelectedImage = [[UIImage imageNamed:@"TabSelected.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];

self.defaultItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
	[UIFont systemFontOfSize:[UIFont systemFontSize] + 3.0], @"font",
	[UIColor blackColor], @"titleColor",
	theUnselectedImage, @"image",
	NULL];
self.selectedItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
	[UIFont systemFontOfSize:[UIFont systemFontSize] + 3.0], @"font",
	[UIColor redColor], @"titleColor",
	theSelectedImage, @"image",
	NULL];

gap1 = 10;
gap2 = 10;
gap3 = 10;
bottomBorderHeight = 0;
}

@end
