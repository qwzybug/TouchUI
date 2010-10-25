//
//  CBookmarkBarItem.m
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

#import "CBookmarkBarItem.h"

@implementation CBookmarkBarItem

@synthesize bookmarkBar;
@synthesize title;
@synthesize font;
@synthesize titleColor;
@synthesize image;
@synthesize selected;
@synthesize action;
@synthesize target;
@synthesize tag;
@synthesize representedObject;
@synthesize view;

- (id)init
{
if ((self = [super init]) != NULL)
	{
//	font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
//	titleColor = [UIColor blackColor];
	}
return(self);
}

- (void)dealloc
{
self.bookmarkBar = NULL;
self.title = NULL;
self.font = NULL;
self.titleColor = NULL;
self.action = NULL;
self.target = NULL;
self.tag = 0;
self.representedObject = NULL;
self.view = NULL;
//
[super dealloc];
}

@end
