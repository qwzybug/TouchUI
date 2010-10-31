//
//  CLLocation_GeohashExtensions.m
//  geohash
//
//  Created by Jonathan Wight on 10/28/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLLocation_GeohashExtensions.h"    

@implementation CLLocation (CLLocation_GeohashExtensions)

- (NSString *)geohash
    {
    return([self geohashWithPrecision:12]);
    }

- (NSString *)geohashWithPrecision:(NSUInteger)inPrecision
    {
    char base32[] = "0123456789bcdefghjkmnpqrstuvwxyz";
    
    CLLocationDegrees longitude = self.coordinate.longitude;
    CLLocationDegrees latitude = self.coordinate.latitude;
    
    NSMutableString *theGeohash = [NSMutableString string];
    
    char ch = 0;
    
    CLLocationDegrees lat_interval[2] = { -90, 90 };
    CLLocationDegrees lon_interval[2] = { -180, 180 };
    
    NSUInteger N = 0;
    
    for (N = 0; theGeohash.length < inPrecision; ++N)
        {
        const NSUInteger bit = 16 >> (N % 5);
        
        if (!(N % 2))
            {
            CLLocationDegrees mid = (lon_interval[0] + lon_interval[1]) / 2.0;
            if (longitude > mid)
                {
                ch |= bit;
                lon_interval[0] = mid;
                }
            else
                {
                lon_interval[1] = mid;
                }
            }
        else
            {
            CLLocationDegrees mid = (lat_interval[0] + lat_interval[1]) / 2.0;
            if (latitude > mid)
                {
                ch |= bit;
                lat_interval[0] = mid;
                }
            else
                {
                lat_interval[1] = mid;
                }
            }
        
        if (N % 5 == 4)
            {
            [theGeohash appendFormat:@"%c", base32[ch]];
            ch = 0;
            }
        }
    
    return(theGeohash);
    }

@end
