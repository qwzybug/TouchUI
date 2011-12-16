//
//  CNetworkActivityManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/16/09.
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

#import "CNetworkActivityManager.h"

@interface CNetworkActivityManager ()
@property (readwrite, nonatomic, assign) NSInteger count;
@property (readwrite, nonatomic, weak) NSTimer *delayTimer;

- (void)delayTimer:(NSTimer *)inTimer;
@end

#pragma mark -

@implementation CNetworkActivityManager

@synthesize delay;

@synthesize count;
@synthesize delayTimer;

static CNetworkActivityManager *gSharedInstance = NULL;

+ (CNetworkActivityManager *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CNetworkActivityManager alloc] init];
        });
    return(gSharedInstance);
    }

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        delay = 0.2;
        }
    return(self);
    }

- (void)dealloc
    {
    [delayTimer invalidate];
    }

- (void)setCount:(NSInteger)inCount
    {
    if (count != inCount)
        {
        if (count <= 0 && inCount > 0)
            {
            if (self.delayTimer != NULL)
                {
                [self.delayTimer invalidate];
                self.delayTimer = NULL;
                }
            self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:self.delay target:self selector:@selector(delayTimer:) userInfo:[NSNumber numberWithBool:YES] repeats:NO];
            }
        else if (count > 0 && inCount <= 0)
            {
            if (self.delayTimer != NULL)
                {
                [self.delayTimer invalidate];
                self.delayTimer = NULL;
                }
            self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:self.delay target:self selector:@selector(delayTimer:) userInfo:[NSNumber numberWithBool:NO] repeats:NO];
            }

        count = inCount;
        }
    }

- (void)addNetworkActivity
    {
    self.count++;
    }

- (void)removeNetworkActivity
    {
    self.count--;
    }

- (void)delayTimer:(NSTimer *)inTimer
    {
    self.delayTimer = NULL;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = [inTimer.userInfo boolValue];
    }

@end
