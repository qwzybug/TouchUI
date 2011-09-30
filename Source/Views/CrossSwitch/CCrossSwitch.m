//
//  CCrossSwitch.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/25/08.
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

#import "CCrossSwitch.h"

#import <QuartzCore/QuartzCore.h>

#import "Geometry.h"

@interface CCrossSwitch()
@property(readwrite,nonatomic, retain) CALayer *imageLayer;
@end

@implementation CCrossSwitch

@synthesize imageLayer;

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != nil)
	{
	self.userInteractionEnabled = YES;
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];

	self.imageLayer = [[CALayer alloc] init];
	self.imageLayer.frame = self.bounds;
//    #warning TODO
//	self.imageLayer.contents = (id)[UIImage imageNamed:@"CrossSwitchButton.png"].CGImage;
	if (on == YES)
		{
		CATransform3D theTransform = CATransform3DIdentity;
		theTransform = CATransform3DRotate(theTransform, DegreesToRadians(45), 0.0, 0.0, 1.0);
		self.imageLayer.transform = theTransform;
		}
	else
		{
		self.imageLayer.transform = CATransform3DIdentity;
		}

	[self.layer addSublayer:self.imageLayer];
	}
return(self);
}


- (BOOL)isOn
{
return(on);
}

- (void)setOn:(BOOL)inOn
{
[self setOn:inOn animated:YES];
}

- (void)setOn:(BOOL)inOn animated:(BOOL)inAnimated
{
if (on != inOn)
	{
	on = inOn;

	if (on == YES)
		{
		CATransform3D theTransform = CATransform3DIdentity;
		theTransform = CATransform3DRotate(theTransform, DegreesToRadians(45), 0.0, 0.0, 1.0);
		self.imageLayer.transform = theTransform;
		}
	else
		{
		self.imageLayer.transform = CATransform3DIdentity;
		}

	[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
[super beginTrackingWithTouch:touch withEvent:event];
[self setOn:!self.on animated:YES];
return(NO);
}

//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
//[self setOn:!self.on animated:YES];
//return(NO);
//}

//- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
//- (void)cancelTrackingWithEvent:(UIEvent *)event;   // event may be nil if cancelled for non-event reasons, e.g. removed from window


//- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
//{
//self.on = !self.on;
//}
//
//- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
//{
//}
//
//- (void)touchesEnded:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
//{
//}

@end
