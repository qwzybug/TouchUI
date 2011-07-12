//
//  geohash.m
//  TouchUI
//
//  Created by Jonathan Wight on 1/1/2000.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTest.h"

int main (int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    CTest *theTest = [[[CTest alloc] init] autorelease];
    [theTest main];

    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantFuture]];

    [pool drain];
    return 0;
}
