//
//  CImageSuite.h
//  knotes
//
//  Created by Jonathan Wight on 11/14/11.
//  Copyright (c) 2011 knotes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CImageSuite : NSObject

@property (readonly, nonatomic, retain) NSString *name;

+ (CImageSuite *)imageSuiteNamed:(NSString *)inName;

- (id)initWithName:(NSString *)inName;
- (UIImage *)imageForState:(UIControlState)inState;


@end
