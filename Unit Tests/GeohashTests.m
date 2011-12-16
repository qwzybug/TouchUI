//
//  Tests.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/29/10.
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
