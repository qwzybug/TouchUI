//
//  CButtonTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/8/09.
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

#import "CButtonTableViewCell.h"

#import "CGlossyButton.h"

@interface CButtonTableViewCell ()
- (IBAction)actionTapped:(id)inSender;
@end

#pragma mark -

@implementation CButtonTableViewCell

@synthesize button;
@synthesize target;
@synthesize action;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) != NULL)
	{
	[self layoutSubviews];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	}
return(self);
}

- (void)dealloc
{
self.button = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)layoutSubviews
{
[super layoutSubviews];

if (self.button == NULL)
	{
	self.button = [CGlossyButton buttonWithTitle:@"TODO" target:self action:@selector(actionTapped:)];
	self.button.frame = self.contentView.bounds;
	[self.contentView addSubview:self.button];
	}
}

- (IBAction)actionTapped:(id)inSender
{
[self.target performSelector:self.action withObject:self];
}


@end
