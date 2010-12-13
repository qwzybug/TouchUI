//
//  CLLocation_GeohashExtensions.h
//  geohash
//
//  Created by Jonathan Wight on 10/28/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

/// Hashes latitude & longitude according to algorithm described at http://en.wikipedia.org/wiki/Geohash (code loosely based on Python implementation at http://www.refactor.fi/software/gis/geohash/ )
@interface CLLocation (CLLocation_GeohashExtensions)

- (NSString *)geohash;
- (NSString *)geohashWithPrecision:(NSUInteger)inPrecision;

@end
