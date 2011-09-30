//
//  CGlossyButton.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/30/10.
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
