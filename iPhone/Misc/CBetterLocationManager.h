//
//  CBetterLocationManager.h
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

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

extern NSString *kBetterLocationManagerDidUpdateToLocationNotification /* = @"CBetterLocationManagerDidUpdateToLocationNotification" */;
extern NSString *kBetterLocationManagerDidReceiveStaleLocationNotification /* = @"CBetterLocationManagerDidReceiveStaleLocationNotification" */;
extern NSString *kBetterLocationManagerDidStartUpdatingLocationNotification /* = @"CBetterLocationManagerDidStartUpdatingLocationNotification" */;
extern NSString *kBetterLocationManagerDidStopUpdatingLocationNotification /* = @"CBetterLocationManagerDidStopUpdatingLocationNotification" */;
extern NSString *kBetterLocationManagerDidFailWithErrorNotification /* = @"CBetterLocationManagerDidFailWithErrorNotification" */;
extern NSString *kBetterLocationManagerDidFailWithUserDeniedErrorNotification /* = @"CBetterLocationManagerDidFailWithUserDeniedErrorNotification" */;

extern NSString *kBetterLocationManagerNewLocationKey /* = @"NewLocation" */;
extern NSString *kBetterLocationManagerOldLocationKey /* = @"OldLocation" */;

@interface CBetterLocationManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	BOOL storeLastLocation;
	CLLocation *previousLocation;
	CLLocation *location;
	BOOL updating;
	BOOL userDenied;
	NSDate *startedUpdatingAtTime;
	CLLocationDistance stopUpdatingAccuracy;
	NSTimeInterval staleLocationThreshold;
	NSTimeInterval stopUpdatingAfterInterval;
	NSTimer *timer;
}

/// This is the CoreLocation location manager object. Generally you should not interact with this directly but go through CBetterLocationManager properties and methods instead.
@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;

/// This is just a proxy for the CLLocationManager distanceFilter property.
@property (readwrite, nonatomic, assign) CLLocationDistance distanceFilter;

/// This is just a proxy for the CLLocationManager desiredAccuracy property.
@property (readwrite, nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/// If YES, then the last location is stored in NSUserDefaults.
@property (readonly, nonatomic, assign) BOOL storeLastLocation;

@property (readonly, nonatomic, retain) CLLocation *previousLocation;

/// This is the location manager's location. It is a little bit more reliable than CLLocationManager.location.
@property (readonly, nonatomic, retain) CLLocation *location;



/// YES if CoreLocation is currenly updating location (i.e. trying to get a fix)
@property (readonly, nonatomic, assign) BOOL updating;

/// YES if CoreLocation has reported the kCLErrorDenied error. This means the user has hit the "No" button in the "This app wants to locate you" dialog box. Once this flag is set the startUpdatingLocation method will always fail with a kCLErrorDenied error.
@property (readonly, nonatomic, assign) BOOL userDenied;

/// This is the date that the last startUpdatingLocation: message was received (i.e. how long has it been since we started updating the location). This is useful to help us decide when to time out update requests.
@property (readonly, nonatomic, retain) NSDate *startedUpdatingAtTime;

/// This is similar to desiredAccuracy except it is used to explicity stop CoreLocation updates when accuracy hits threshold.
@property (readwrite, nonatomic, assign) CLLocationDistance stopUpdatingAccuracy;

/// Location data that is older than the threshold (in seconds) will be considered stale and ignored (although you will get a kBetterLocationManagerDidReceiveStaleLocationNotification notification)
@property (readwrite, nonatomic, assign) NSTimeInterval staleLocationThreshold;

/// This property specifies how long to wait while updating location before giving up.
@property (readwrite, nonatomic, assign) NSTimeInterval stopUpdatingAfterInterval;

+ (CBetterLocationManager *)instance;

- (BOOL)startUpdatingLocation:(NSError **)outError;
- (BOOL)stopUpdatingLocation:(NSError **)outError;

@end
