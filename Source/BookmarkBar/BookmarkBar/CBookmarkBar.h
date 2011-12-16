//
//  CBookmarkBar.h
//  TouchCode
//
//  Created by Jonathan Wight on 1/3/10.
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
