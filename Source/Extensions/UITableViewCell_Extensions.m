//
//  UITableViewCell_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/22/09.
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

#import "UITableViewCell_Extensions.h"

@implementation UITableViewCell (UITableViewCell_Extensions)

+ (UITableViewCell *)cellWithPlaceholderText:(NSString *)inPlaceholderText reuseIdentifier:(NSString *)inReuseIdentifier
{
UITableViewCell *theCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inReuseIdentifier];
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
UIImageView *theImageView = [[UIImageView alloc] initWithImage:inImage];
self.accessoryView = theImageView;
}

- (void)setAccessoryImageName:(NSString *)inString
{
[self setAccessoryImage:[UIImage imageNamed:inString]];
}

@end
