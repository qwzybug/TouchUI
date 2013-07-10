//
//  UITableView_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 7/15/09.
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

#import "UITableView_Extensions.h"

@implementation UITableView (UITableView_Extensions)

- (void)setTableHeaderLabelText:(NSString *)inText
{
#define kReallyBigNumber 480 * 10

if (self.style == UITableViewStyleGrouped)
	{
	UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, kReallyBigNumber)];
	theLabel.lineBreakMode = NSLineBreakByWordWrapping;
	theLabel.numberOfLines = 0;
	theLabel.text = inText;
	theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	theLabel.opaque = NO;
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
	//theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
	theLabel.frame = CGRectMake(20, 10, 280, theSize.height);

	UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(theLabel.frame))];
	//theView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[theView addSubview:theLabel];

	self.tableHeaderView = theView;
	}
else
	{
	CGFloat theWidth = self.bounds.size.width;
	
	UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, theWidth - 40.0, kReallyBigNumber)];
	theLabel.textAlignment = NSTextAlignmentCenter;
	theLabel.lineBreakMode = NSLineBreakByWordWrapping;
	theLabel.numberOfLines = 0;
	theLabel.text = inText;
	theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	theLabel.opaque = NO;
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
	theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
	theLabel.frame = CGRectMake(20, 10, theWidth - 40.0, theSize.height);

	UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, theWidth, CGRectGetMaxY(theLabel.frame) + 10)];
	theView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[theView addSubview:theLabel];

	self.tableHeaderView = theView;
	}
}

- (void)setTableFooterLabelText:(NSString *)inText
{
#define kReallyBigNumber 480 * 10

UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, kReallyBigNumber)];
theLabel.lineBreakMode = NSLineBreakByWordWrapping;
theLabel.numberOfLines = 0;
theLabel.text = inText;
theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
theLabel.opaque = NO;
theLabel.backgroundColor = [UIColor clearColor];
//theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
theLabel.frame = CGRectMake(20, 0, 280, theSize.height);

UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(theLabel.frame))];
//theView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
[theView addSubview:theLabel];

self.tableFooterView = theView;
}

@end
