//
//  CGlossyButton.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/30/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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

#import "CGlossyButton.h"


@implementation CGlossyButton

+ (CGlossyButton *)buttonWithTitle:(NSString *)inTitle target:(id)inTarget action:(SEL)inAction
{
CGlossyButton *theButton = [self buttonWithType:UIButtonTypeCustom];
[theButton setTitle:inTitle forState:UIControlStateNormal];
theButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
theButton.titleLabel.textColor = [UIColor darkTextColor];
theButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;

NSString *theImagePrefix = @"glossyButton";

UIImage *theImage = NULL;

theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-normal.png", theImagePrefix]];
if (theImage)
	{
	theImage = [theImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	[theButton setBackgroundImage:theImage forState:UIControlStateNormal];
	}

theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled.png", theImagePrefix]];
if (theImage)
	{
	theImage = [theImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	[theButton setBackgroundImage:theImage forState:UIControlStateDisabled];
	}

theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-highlighted.png", theImagePrefix]];
if (theImage)
	{
	theImage = [theImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	[theButton setBackgroundImage:theImage forState:UIControlStateHighlighted];
	}


[theButton addTarget:inTarget action:inAction forControlEvents:UIControlEventTouchUpInside];

return(theButton);
}

@end
