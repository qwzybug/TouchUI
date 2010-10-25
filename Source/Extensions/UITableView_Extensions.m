//
//  UITableView_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 7/15/09.
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

#import "UITableView_Extensions.h"

@implementation UITableView (UITableView_Extensions)

- (void)setTableHeaderLabelText:(NSString *)inText
{
#define kReallyBigNumber 480 * 10

if (self.style == UITableViewStyleGrouped)
	{
	UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, kReallyBigNumber)] autorelease];
	theLabel.lineBreakMode = UILineBreakModeWordWrap;
	theLabel.numberOfLines = 0;
	theLabel.text = inText;
	theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	theLabel.opaque = NO;
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
	//theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
	theLabel.frame = CGRectMake(20, 10, 280, theSize.height);

	UIView *theView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(theLabel.frame))] autorelease];
	//theView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[theView addSubview:theLabel];

	self.tableHeaderView = theView;
	}
else
	{
	CGFloat theWidth = self.bounds.size.width;
	
	UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, theWidth - 40.0, kReallyBigNumber)] autorelease];
	theLabel.textAlignment = UITextAlignmentCenter;
	theLabel.lineBreakMode = UILineBreakModeWordWrap;
	theLabel.numberOfLines = 0;
	theLabel.text = inText;
	theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	theLabel.opaque = NO;
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
	theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
	theLabel.frame = CGRectMake(20, 10, theWidth - 40.0, theSize.height);

	UIView *theView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, theWidth, CGRectGetMaxY(theLabel.frame) + 10)] autorelease];
	theView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[theView addSubview:theLabel];

	self.tableHeaderView = theView;
	}
}

- (void)setTableFooterLabelText:(NSString *)inText
{
#define kReallyBigNumber 480 * 10

UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, kReallyBigNumber)] autorelease];
theLabel.lineBreakMode = UILineBreakModeWordWrap;
theLabel.numberOfLines = 0;
theLabel.text = inText;
theLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
theLabel.textColor = [UIColor colorWithRed:0.298f green:0.337f blue:0.424f alpha:1.0f];
theLabel.opaque = NO;
theLabel.backgroundColor = [UIColor clearColor];
//theLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

CGSize theSize = [theLabel.text sizeWithFont:theLabel.font constrainedToSize:theLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
theLabel.frame = CGRectMake(20, 0, 280, theSize.height);

UIView *theView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(theLabel.frame))] autorelease];
//theView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
[theView addSubview:theLabel];

self.tableFooterView = theView;
}

@end
