//
//  CBookmarkBarItem.h
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

#import <Foundation/Foundation.h>

// UIBarButtonItem

@class CBookmarkBar;
@class CBookmarkBarItemView;

@interface CBookmarkBarItem : NSObject {
	CBookmarkBar *bookmarkBar;
	NSString *title;
	UIFont *font;
	UIColor *titleColor;
	UIImage *image;
	BOOL selected;
	SEL action;
	id target;
	NSInteger tag;
	id representedObject;
	id view;
}

@property (readwrite, nonatomic, assign) CBookmarkBar *bookmarkBar;
@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) UIFont *font;
@property (readwrite, nonatomic, retain) UIColor *titleColor;
@property (readwrite, nonatomic, retain) UIImage *image;

@property (readwrite, nonatomic, assign) BOOL selected;
@property (readwrite, nonatomic, assign) SEL action;
@property (readwrite, nonatomic, assign) id target;
@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, retain) id representedObject;
@property (readwrite, nonatomic, assign) CBookmarkBarItemView *view;

@end
