//
//  CBetterLocationManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/06/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "CBetterLocationManager.h"

static CBetterLocationManager *gInstance = NULL;

NSString *kBetterLocationManagerDidUpdateToLocationNotification = @"CBetterLocationManagerDidUpdateToLocationNotification";
NSString *kBetterLocationManagerDidReceiveStaleLocationNotification = @"CBetterLocationManagerDidReceiveStaleLocationNotification";
NSString *kBetterLocationManagerDidStartUpdatingLocationNotification = @"CBetterLocationManagerDidStartUpdatingLocationNotification";
NSString *kBetterLocationManagerDidStopUpdatingLocationNotification = @"CBetterLocationManagerDidStopUpdatingLocationNotification";
NSString *kBetterLocationManagerDidFailWithErrorNotification = @"CBetterLocationManagerDidFailWithErrorNotification";
NSString *kBetterLocationManagerDidFailWithUserDeniedErrorNotification = @"CBetterLocationManagerDidFailWithUserDeniedErrorNotification";

NSString *kBetterLocationManagerNewLocationKey = @"NewLocation";
NSString *kBetterLocationManagerOldLocationKey = @"OldLocation";

@interface CBetterLocationManager ()
@property (readwrite, nonatomic, retain) CLLocation *previousLocation;
@property (readwrite, nonatomic, retain) CLLocation *location;
@property (readwrite, nonatomic, assign) BOOL updating;
@property (readwrite, nonatomic, assign) BOOL userDenied;
@property (readwrite, nonatomic, retain) NSDate *startedUpdatingAtTime;
@property (readwrite, nonatomic, assign) NSTimer *timer;

- (void)postNewLocation:(CLLocation *)inNewLocation oldLocation:(CLLocation *)inOldLocation;

- (void)stopUpdatingTimerDidFire:(NSTimer *)inTimer;
@end

@implementation CBetterLocationManager

@synthesize storeLastLocation;
@synthesize previousLocation;
@synthesize location;
@synthesize updating;
@synthesize userDenied;
@synthesize startedUpdatingAtTime;
@synthesize stopUpdatingAccuracy;
@synthesize staleLocationThreshold;
@synthesize timer;

// [[[CLLocation alloc] initWithLatitude:34.5249 longitude:-82.6683] autorelease];

+ (CBetterLocationManager *)instance
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
	storeLastLocation = YES;
	stopUpdatingAccuracy = kCLLocationAccuracyHundredMeters;
	staleLocationThreshold = 120.0;
	stopUpdatingAfterInterval = 10.0;
	}
return(self);
}

- (void)dealloc
{
[self stopUpdatingLocation:NULL];

[self.timer invalidate];
self.timer = NULL;

self.locationManager = NULL;
self.startedUpdatingAtTime = NULL;

[super dealloc];
}

#pragma mark -

- (CLLocationManager *)locationManager
{
if (locationManager == NULL)
	{
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;

	self.location = locationManager.location;
	if (self.location)
		[self postNewLocation:self.location oldLocation:NULL];
	}
return(locationManager);
}

- (void)setLocationManager:(CLLocationManager *)inLocationManager
{
if (locationManager != inLocationManager)
	{
	if (locationManager)
		{
		locationManager.delegate = NULL;
		[locationManager release];
		locationManager = NULL;
		}

	if (inLocationManager)
		{
		locationManager = inLocationManager;
		locationManager.delegate = self;
		}
	}
}

- (CLLocationDistance)distanceFilter
{
return(self.locationManager.distanceFilter);
}

- (void)setDistanceFilter:(CLLocationDistance)inDistanceFilter
{
self.locationManager.distanceFilter = inDistanceFilter;
}

- (CLLocationAccuracy)desiredAccuracy
{
return(self.locationManager.desiredAccuracy);
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)inDesiredAccuracy
{
self.locationManager.desiredAccuracy = inDesiredAccuracy;
}

#pragma mark -

- (BOOL)startUpdatingLocation:(NSError **)outError
{
if ([CLLocationManager locationServicesEnabled] == YES)
	{
	NSData *theData = [[NSUserDefaults standardUserDefaults] objectForKey:@"BetterLocationManager_LastLocation"];
	if (theData)
		{
		CLLocation *theLastLocation = [NSKeyedUnarchiver unarchiveObjectWithData:theData];
		self.previousLocation = theLastLocation;
		}
	}

if (self.updating == NO)
	{
	if (self.userDenied == YES)
		{
		if (outError)
			*outError = [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied userInfo:NULL];
		return(NO);
		}

	self.startedUpdatingAtTime = [NSDate date];
	self.updating = YES;
	[self.locationManager startUpdatingLocation];
	[[NSNotificationCenter defaultCenter] postNotificationName:kBetterLocationManagerDidStartUpdatingLocationNotification object:self userInfo:NULL];
	if (self.stopUpdatingAfterInterval > 0.0)
		{
		if (self.timer)
			{
			[self.timer invalidate];
			self.timer = NULL;
			}

		self.timer = [NSTimer scheduledTimerWithTimeInterval:self.stopUpdatingAfterInterval target:self selector:@selector(stopUpdatingTimerDidFire:) userInfo:NULL repeats:NO];
		}
	}
return(YES);
}

- (BOOL)stopUpdatingLocation:(NSError **)outError
{
if (self.updating == YES)
	{
	if (self.userDenied == NO && self.location != NULL)
		{
		NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];
		[theUserInfo setObject:self.location forKey:kBetterLocationManagerNewLocationKey];
		[[NSNotificationCenter defaultCenter] postNotificationName:kBetterLocationManagerDidStopUpdatingLocationNotification object:self userInfo:theUserInfo];
		}
	self.updating = NO;
	if (self.timer)
		{
		[self.timer invalidate];
		self.timer = NULL;
		}

	if (locationManager)
		{
		[self.locationManager stopUpdatingLocation];
		}
	}
return(YES);
}

- (NSTimeInterval)stopUpdatingAfterInterval
{
return(stopUpdatingAfterInterval);
}

- (void)setStopUpdatingAfterInterval:(NSTimeInterval)inStopUpdatingAfterInterval
{
stopUpdatingAfterInterval = inStopUpdatingAfterInterval;
if (updating == YES && stopUpdatingAfterInterval > 0.0)
	{
	if (self.timer)
		{
		[self.timer invalidate];
		self.timer = NULL;
		}
	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.stopUpdatingAfterInterval target:self selector:@selector(stopUpdatingTimerDidFire:) userInfo:NULL repeats:NO];
	}
}

#pragma mark -

- (void)postNewLocation:(CLLocation *)inNewLocation oldLocation:(CLLocation *)inOldLocation
{
if (inNewLocation == NULL)
	return;

if (self.storeLastLocation)
	{
	NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:inNewLocation];
	[[NSUserDefaults standardUserDefaults] setObject:theData forKey:@"BetterLocationManager_LastLocation"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	}

self.previousLocation = inOldLocation;

NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
	inNewLocation, kBetterLocationManagerNewLocationKey,
	inOldLocation, kBetterLocationManagerOldLocationKey,
	NULL];

NSTimeInterval theAge = fabs([inNewLocation.timestamp timeIntervalSinceNow]);
if (self.staleLocationThreshold > 0.0 && theAge >= self.staleLocationThreshold)
	{
	[[NSNotificationCenter defaultCenter] postNotificationName:kBetterLocationManagerDidReceiveStaleLocationNotification object:self userInfo:theUserInfo];

	return;
	}

self.location = inNewLocation;

if (self.stopUpdatingAccuracy > 0.0 && inNewLocation.horizontalAccuracy <= self.stopUpdatingAccuracy)
	{
	[self stopUpdatingLocation:NULL];
	}

[[NSNotificationCenter defaultCenter] postNotificationName:kBetterLocationManagerDidUpdateToLocationNotification object:self userInfo:theUserInfo];
}

#pragma mark -

- (void)stopUpdatingTimerDidFire:(NSTimer *)inTimer
{
if (self.timer)
	{
	[self.timer invalidate];
	self.timer = NULL;
	}

[self stopUpdatingLocation:NULL];
}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)inNewLocation fromLocation:(CLLocation *)inOldLocation
{
[self postNewLocation:inNewLocation oldLocation:inOldLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
return(YES);
}

//- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
//{
//}
//
//- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
//{
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)inError
{
if ([inError.domain isEqualToString:kCLErrorDomain] && inError.code == kCLErrorDenied)
	{
	self.userDenied = YES;

	// If we get a user denied error we want to clear thelast stored location.
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BetterLocationManager_LastLocation"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	// We ought to stop updating here and set the location manager to NULL. But this seems to cause weird problems. Better to just set a flag and move on.
//	[self stopUpdatingLocation:NULL];
//	self.locationManager = NULL;

	NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys: inError, @"Error", NULL];
	[[NSNotificationCenter defaultCenter] postNotificationName:kBetterLocationManagerDidFailWithUserDeniedErrorNotification object:self userInfo:theUserInfo];
	}

NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys: inError, @"Error", NULL];
[[NSNotificationCenter defaultCenter] postNotificationName:kBetterLocationManagerDidFailWithErrorNotification object:self userInfo:theUserInfo];
}

//- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
//{
//}

@end
