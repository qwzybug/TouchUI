//
//  CBetterLocationManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/06/08.
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

#import "CBetterLocationManager.h"

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
@property (readwrite, nonatomic, retain) NSDate *startedUpdatingAtTime;
@property (readwrite, nonatomic, weak) NSTimer *timer;

- (void)postNewLocation:(CLLocation *)inNewLocation oldLocation:(CLLocation *)inOldLocation;

- (void)stopUpdatingTimerDidFire:(NSTimer *)inTimer;
@end

@implementation CBetterLocationManager
@synthesize locationManager;
@synthesize storeLastLocation;
@synthesize previousLocation;
@synthesize location;
@synthesize updating;
@synthesize startedUpdatingAtTime;
@synthesize stopUpdatingAccuracy;
@synthesize staleLocationThreshold;
@synthesize stopUpdatingAfterInterval;

@synthesize timer;

// [[[CLLocation alloc] initWithLatitude:34.5249 longitude:-82.6683] autorelease];

static CBetterLocationManager *gSharedInstance = NULL;

+ (CBetterLocationManager *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CBetterLocationManager alloc] init];
        });
    return(gSharedInstance);
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
            {
            [self postNewLocation:self.location oldLocation:NULL];
            }
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
        if (self.location != NULL)
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
