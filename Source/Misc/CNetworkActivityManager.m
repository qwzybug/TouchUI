//
//  CNetworkActivityManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/16/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CNetworkActivityManager.h"

static CNetworkActivityManager *gInstance = NULL;

@interface CNetworkActivityManager ()
@property (readwrite, assign) NSInteger count;
@property (readwrite, assign) NSTimer *delayTimer;

- (void)delayTimer:(NSTimer *)inTimer;
@end

#pragma mark -

@implementation CNetworkActivityManager

@synthesize delay;
@synthesize delayTimer;

+ (id)instance
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
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
delayTimer = NULL;
//
[super dealloc];
}

- (NSInteger)count
{
return(count);
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
