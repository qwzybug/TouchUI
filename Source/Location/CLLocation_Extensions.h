//
//  CLLocation_Extensions.h
//  AnythingDB
//
//  Created by Jonathan Wight on 10/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (CLLocation_Extensions)

@property (readonly, nonatomic, assign) NSTimeInterval age;
@property (readonly, nonatomic, assign) BOOL stale;

@end
