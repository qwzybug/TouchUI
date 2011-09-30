//
//  CBetterLocationManager.h
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
}

/// This is the CoreLocation location manager object. Generally you should not interact with this directly but go through CBetterLocationManager properties and methods instead.
@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;

/// This is just a proxy for the CLLocationManager distanceFilter property.
@property (readwrite, nonatomic, assign) CLLocationDistance distanceFilter;

/// This is just a proxy for the CLLocationManager desiredAccuracy property.
@property (readwrite, nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/// If YES, then the last location is stored in NSUserDefaults.
@property (readwrite, nonatomic, assign) BOOL storeLastLocation;

@property (readonly, nonatomic, retain) CLLocation *previousLocation;

/// This is the location manager's location. It is a little bit more reliable than CLLocationManager.location.
@property (readonly, nonatomic, retain) CLLocation *location;

/// YES if CoreLocation is currenly updating location (i.e. trying to get a fix)
@property (readonly, nonatomic, assign) BOOL updating;

/// This is the date that the last startUpdatingLocation: message was received (i.e. how long has it been since we started updating the location). This is useful to help us decide when to time out update requests.
@property (readonly, nonatomic, retain) NSDate *startedUpdatingAtTime;

/// This is similar to desiredAccuracy except it is used to explicity stop CoreLocation updates when accuracy hits threshold.
@property (readwrite, nonatomic, assign) CLLocationDistance stopUpdatingAccuracy;

/// Location data that is older than the threshold (in seconds) will be considered stale and ignored (although you will get a kBetterLocationManagerDidReceiveStaleLocationNotification notification)
@property (readwrite, nonatomic, assign) NSTimeInterval staleLocationThreshold;

/// This property specifies how long to wait while updating location before giving up.
@property (readwrite, nonatomic, assign) NSTimeInterval stopUpdatingAfterInterval;

+ (CBetterLocationManager *)sharedInstance;

- (BOOL)startUpdatingLocation:(NSError **)outError;
- (BOOL)stopUpdatingLocation:(NSError **)outError;

@end
