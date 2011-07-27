//
//  CLLocation_GeohashExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/28/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLLocation_GeohashExtensions.h"    

static void refine_interval(double interval[2], int cd, int mask);

static void refine_interval(double interval[2], int cd, int mask)
    {
	if (cd & mask)
		interval[0] = (interval[0] + interval[1])/2;
    else
		interval[1] = (interval[0] + interval[1])/2;
    }

@implementation CLLocation (CLLocation_GeohashExtensions)

- (id)initWithGeohash:(NSString *)inGeohash;
	{
//    NSAssert(NO, @"Not implemented");

    CLLocationDegrees theLatitude = 0;
    CLLocationDegrees theLongitude = 0;

    BOOL is_even = 1;
	double lat[2]; double lon[2];
	lat[0] = -90.0;  lat[1] = 90.0;
	lon[0] = -180.0; lon[1] = 180.0;
	double lat_err = 90.0; double lon_err = 180.0;

    char BASE32[] =  "0123456789bcdefghjkmnpqrstuvwxyz";
    int BITS[] = { 16, 8, 4, 2, 1 };

	for (int i=0; i< inGeohash.length; i++) {
		unichar c = [inGeohash characterAtIndex:i];
		int cd = strchr(BASE32, c) - BASE32;
		for (int j=0; j<5; j++) {
			int mask = BITS[j];
			if (is_even) {
				lon_err /= 2;
				refine_interval(lon, cd, mask);
			} else {
				lat_err /= 2;
				refine_interval(lat, cd, mask);
			}
			is_even = !is_even;
		}
	}
	theLatitude = (lat[0] + lat[1])/2;
	theLongitude = (lon[0] + lon[1])/2;
    
	if ((self = [self initWithLatitude:theLatitude longitude:theLongitude]) != NULL)
		{
		}
	return(self);
	}

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

#if TESTING

+ (void)test_1
    {
    NSLog(@">>>> test_1");
    
    STAssertTrue((1+1)==3, @"Compiler isn't feeling well today :-(" );
    }

#endif

@end

