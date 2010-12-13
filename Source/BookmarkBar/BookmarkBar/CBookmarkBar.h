//
//  CBookmarkBar.h
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

#import <UIKit/UIKit.h>

@class CBookmarkBarItem;
@class CBookmarkBarItemView;

@interface CBookmarkBar : UIView {
	NSArray *items;
	CBookmarkBarItem *selectedItem;
	//
	NSDictionary *defaultItemAttributes;
	NSDictionary *selectedItemAttributes;
	//
	CGFloat gap1;
	CGFloat gap2;
	CGFloat gap3;
	CGFloat bottomBorderHeight;
	
	
	UIScrollView *scrollView;
}

@property (readwrite, nonatomic, retain) NSArray *items;
@property (readwrite, nonatomic, retain) CBookmarkBarItem *selectedItem;

@property (readwrite, nonatomic, retain) NSDictionary *defaultItemAttributes;
@property (readwrite, nonatomic, retain) NSDictionary *selectedItemAttributes;

@property (readonly, nonatomic, assign) CGFloat gap1;
@property (readonly, nonatomic, assign) CGFloat gap2;
@property (readonly, nonatomic, assign) CGFloat gap3;
@property (readonly, nonatomic, assign) CGFloat bottomBorderHeight;

@property (readonly, nonatomic, retain) UIScrollView *scrollView;

- (CBookmarkBarItemView *)newViewForItem:(CBookmarkBarItem *)inItem;

@end
