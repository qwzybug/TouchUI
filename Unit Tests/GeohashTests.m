//
//  Tests.m
//  geohash
//
//  Created by Jonathan Wight on 10/29/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "GeohashTests.h"

#import "CLLocation_GeohashExtensions.h"

@implementation GeohashTests

- (void)testPositive1
    {
    CLLocation *theLocation = [[[CLLocation alloc] initWithLatitude:37.7793 longitude:-122.4192] autorelease];
    STAssertEqualObjects([theLocation geohash], @"9q8yym903guq", @"1");
    }

- (void)testPositive2
    {
    CLLocation *theLocation = [[[CLLocation alloc] initWithLatitude:42.6 longitude:-5.6] autorelease];
    STAssertEqualObjects([theLocation geohashWithPrecision:5], @"ezs42", @"1");
    }

- (void)testPrecision1
    {
    CLLocation *theLocation = [[[CLLocation alloc] initWithLatitude:37.7793 longitude:-122.4192] autorelease];
    NSString *theP12Geohash = [theLocation geohashWithPrecision:12];
    for (int N = 1; N != 12; ++N)
        {
        NSString *theGeohash = [theLocation geohashWithPrecision:N];
        STAssertEqualObjects([theP12Geohash substringToIndex:N], theGeohash, @"2");
        }
    }

- (void)testPrecision2
    {
    CLLocation *theLocation = [[[CLLocation alloc] initWithLatitude:37.7793 longitude:-122.4192] autorelease];
    NSString *theGeohash = [theLocation geohashWithPrecision:7];
    STAssertTrue([theGeohash length] == 7, @"4");
    }

@end
