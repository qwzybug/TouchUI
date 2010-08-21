//
//  UITableViewCell_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/22/09.
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

#import "UITableViewCell_Extensions.h"

@implementation UITableViewCell (UITableViewCell_Extensions)

+ (UITableViewCell *)cellWithPlaceholderText:(NSString *)inPlaceholderText reuseIdentifier:(NSString *)inReuseIdentifier
{
UITableViewCell *theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inReuseIdentifier] autorelease];
theCell.accessoryType = UITableViewCellAccessoryNone;
theCell.selectionStyle = UITableViewCellSelectionStyleNone;
theCell.textLabel.frame = CGRectMake(0, 0, 320, 44);
theCell.textLabel.textAlignment = UITextAlignmentCenter;
theCell.textLabel.textColor = [UIColor grayColor];
theCell.textLabel.text = inPlaceholderText;
return(theCell);
}

- (id)initWithReuseIdentifier:(NSString *)inReuseIdentifier
{
if ((self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inReuseIdentifier]) != NULL)
	{
	}
return(self);
}

- (void)setAccessoryImage:(UIImage *)inImage
{
UIImageView *theImageView = [[[UIImageView alloc] initWithImage:inImage] autorelease];
self.accessoryView = theImageView;
}

- (void)setAccessoryImageName:(NSString *)inString
{
[self setAccessoryImage:[UIImage imageNamed:inString]];
}

@end
