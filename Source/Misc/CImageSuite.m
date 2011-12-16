//
//  CImageSuite.m
//  knotes
//
//  Created by Jonathan Wight on 11/14/11.
//  Copyright (c) 2011 knotes. All rights reserved.
//

#import "CImageSuite.h"

#import "CImageLoader.h"

@implementation CImageSuite

@synthesize name;

+ (CImageSuite *)imageSuiteNamed:(NSString *)inName
    {
    return([[self alloc] initWithName:inName]);
    }
    
- (id)initWithName:(NSString *)inName
    {
    if ((self = [super init]) != NULL)
        {
        name = inName;
        }
    return self;
    }

- (UIImage *)imageForState:(UIControlState)inState
    {
    return([[CImageLoader sharedInstance] imageNamed:self.name state:inState]);
    }

@end
