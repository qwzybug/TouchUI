//
//  CBetterLabel.m
//  TouchCode
//
//  Created by brandon on 7/13/09.
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
