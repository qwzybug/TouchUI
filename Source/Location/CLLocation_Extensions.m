//
//  CLLocation_Extensions.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLLocation_Extensions.h"


@implementation CLLocation (CLLocation_Extensions)

- (NSTimeInterval)age
    {
    return([[NSDate date] timeIntervalSinceDate:self.timestamp]);
    }

- (BOOL)stale
    {
    return(self.age > 5 * 60);
    }

@end
