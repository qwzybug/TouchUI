//
//  CPressGestureRecognizer.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/22/11.
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
//  or implied, of 2011 Jonathan Wight.

#import "CPressGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface CPressGestureRecognizer ()
@property (readwrite, nonatomic, assign) CGPoint initialLocation;
@end

@implementation CPressGestureRecognizer

@synthesize numberOfTouchesRequired;
@synthesize allowableMovement;

@synthesize initialLocation;

- (id)initWithTarget:(id)target action:(SEL)action
    {
    if ((self = [super initWithTarget:target action:action]) != NULL)
        {
        numberOfTouchesRequired = 1;
        allowableMovement = 10.0;
        }
    return(self);
    }

- (void)setState:(UIGestureRecognizerState)inState
    {
    [super setState:inState];
    }

- (void)reset
    {
    self.state = UIGestureRecognizerStateCancelled;

    [super reset];
    }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
    {
    [super touchesBegan:touches withEvent:event];

    if (touches.count >= self.numberOfTouchesRequired)
        {
        self.state = UIGestureRecognizerStateBegan;

        self.initialLocation = [self locationInView:self.view];
        }
    }

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
    {
    [super touchesMoved:touches withEvent:event];

    CGPoint theCurrentPoint = [self locationInView:self.view];

    CGFloat DX = fabsf(theCurrentPoint.x - self.initialLocation.x);
    CGFloat DY = fabsf(theCurrentPoint.y - self.initialLocation.y);

    if (sqrt(DX * DX + DY * DY) > self.allowableMovement)
        {
        self.state = UIGestureRecognizerStateCancelled;
        }
    else
        {
        self.state = UIGestureRecognizerStateChanged;
        }
    }

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
    {
    [super touchesEnded:touches withEvent:event];

    self.state = UIGestureRecognizerStateEnded;
    }

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
    {
    [super touchesCancelled:touches withEvent:event];

    self.state = UIGestureRecognizerStateCancelled;
    }



@end
