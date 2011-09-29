//
//  UIActionSheet_BlocksExtensions.h
//  AnythingDB
//
//  Created by Jonathan Wight on 10/18/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (UIActionSheet_BlocksExtensions)

- (NSUInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))inHandler;

@end
