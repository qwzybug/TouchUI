//
//  MKMapView+Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/23/11.
//  Copyright 2011 Jonathan Wight. All rights reserved.
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
//  THIS SOFTWARE IS PROVIDED BY 2011 JONATHAN WIGHT ``AS IS'' AND ANY EXPRESS OR IMPLIED
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
//  or implied, of 2011 Jonathan Wight.

#import "MKMapView_Extensions.h"

@implementation MKMapView (Extensions)

- (MKMapPoint)centerMapPoint
    {
    return(MKMapPointForCoordinate(self.centerCoordinate));
    }

- (void)setCenterMapPoint:(MKMapPoint)inCenterMapPoint
    {
    self.centerCoordinate = MKCoordinateForMapPoint(inCenterMapPoint);
    }

/// zoomLevel for MKMapView. zoomLevel should be consistent across multiple map views. Use this to set multiple map views to the same zoom level. Does not currently map to Google Map zoom levels - but _could_ be easily.
- (double)zoomLevel
    {
    // TODO:define new type. TODO:should zoomLevel be a CLLocationAccuracy or CLLocationDistance perhaps instead of a double?
    double theZoomLevel = 20 - log2(self.visibleMapRect.size.width / self.bounds.size.width);
    return(theZoomLevel);
    }

- (void)setZoomLevel:(double)inZoomLevel
    {
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:inZoomLevel animated:NO];
    }

- (void)setCenterCoordinate:(CLLocationCoordinate2D)inCoordinate zoomLevel:(double)inZoomLevel animated:(BOOL)inAnimated
    {
    const MKMapPoint theCurrentCenter = MKMapPointForCoordinate(inCoordinate);
    const double theFector = exp2(20 - inZoomLevel);
    const MKMapSize theSize = {
        .width = self.bounds.size.width * theFector,
        .height = self.bounds.size.height * theFector,
        };
    const MKMapPoint theOrigin = {
        .x = theCurrentCenter.x - theSize.width * 0.5,
        .y = theCurrentCenter.y - theSize.height * 0.5,
        };

    self.visibleMapRect =  [self mapRectThatFits:(MKMapRect){ .origin = theOrigin, .size = theSize }];
    }

@end

NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D inCLLocationCoordinate2D)
    {
    return([NSString stringWithFormat:@"%f,%f", inCLLocationCoordinate2D.latitude, inCLLocationCoordinate2D.longitude]);
    }
