//
//  CTest.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/28/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTest.h"

#import <CoreLocation/CoreLocation.h>

#import "CLLocation_GeohashExtensions.h"

@interface CTest () <CLLocationManagerDelegate>
@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation CTest

@synthesize locationManager;

- (void)main
    {
    
    CLLocation *theLocation = [[[CLLocation alloc] initWithLatitude:37.7793 longitude:-122.4192] autorelease];
    
    NSLog(@"%@", [theLocation geohashWithPrecision:12]);

    theLocation = [[[CLLocation alloc] initWithLatitude:42.6 longitude:-5.6] autorelease];
    NSLog(@"%@", [theLocation geohashWithPrecision:12]);
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    
//    [self.locationManager startUpdatingLocation];
    }

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	fromLocation:(CLLocation *)oldLocation
{
NSLog(@"%@", [newLocation geohash]);
}

@end
