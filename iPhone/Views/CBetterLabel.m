//
//  CBetterLabel.m
//  TouchCode
//
//  Created by brandon on 7/13/09.
//  Copyright 2009 Small Society. All rights reserved.
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

#import "CBetterLabel.h"


@implementation CBetterLabel

@synthesize variableHeightText;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != NULL)
	{
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (UITextVerticalAlignment)verticalAlignment
{
	return verticalAlignment;
}

- (void)setVerticalAlignment:(UITextVerticalAlignment)vertAlignment
{
	verticalAlignment = vertAlignment;
	[self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	CGRect result;
	switch (verticalAlignment)
	{
		case UITextVerticalAlignmentTop:
			result = CGRectMake(bounds.origin.x, bounds.origin.y, rect.size.width, rect.size.height);
			break;
		case UITextVerticalAlignmentCenter:
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height) / 2, rect.size.width, rect.size.height);
			break;
		case UITextVerticalAlignmentBottom:
			result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height);
			break;
		default:
			result = bounds;
			break;
	}
	return result;
}

- (CGFloat)heightForText:(NSString*)newText
{
	if (!newText) return 0;
	CGSize line1Size = [newText sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 1) lineBreakMode:self.lineBreakMode];
	CGSize size = [newText sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, line1Size.height * self.numberOfLines) lineBreakMode:self.lineBreakMode];
	return size.height;
}

- (CGSize)sizeThatFits:(CGSize)size {
	size.height = [self heightForText:self.text];
	return size;
}

- (void)setVariableHeightText:(BOOL)value
{
	variableHeightText = value;
	
	// recalc the rectangle.
	[self setText:self.text];
}

- (void)setText:(NSString*)newText
{
	if (variableHeightText)
	{
		CGFloat height = [self heightForText:newText];
		if (self.frame.size.height != height)
		{
			CGRect rect = self.frame;
			rect.size.height = height;
			self.frame = rect;
		}
	}
	
	[super setText:newText];
}

- (void)drawTextInRect:(CGRect)rect
{
	CGRect newRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
	[super drawTextInRect:newRect];
}

@end
