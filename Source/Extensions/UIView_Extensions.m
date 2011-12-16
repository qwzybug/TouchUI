//
//  UIView_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/13/09.
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

#import "UIView_Extensions.h"

@implementation UIView (UIView_Extensions)

- (void)setClipsToBoundsRecursively:(BOOL)clips;
{
UIView *currentView = self;    
do {
	currentView.clipsToBounds = clips;
    }
while ((currentView = [currentView superview]));
}

- (void)dump:(NSInteger)inDepth
{
char theSpaces[] = "..........";

printf("%.*s%s %s (bgColor:%s, hidden:%d, opaque:%d, alpha:%g, clipsToBounds:%d)\n", (int)MIN(inDepth, strlen(theSpaces)), theSpaces, [[self description] UTF8String], [NSStringFromCGRect(self.frame) UTF8String], [[self.backgroundColor description] UTF8String], self.hidden, self.opaque, self.alpha, self.clipsToBounds);
for (UIView *theView in self.subviews)
	{
	[theView dump:inDepth + 1];
	}
}

- (void)moveToSuperview:(UIView *)inSuperview
{
if (inSuperview != self.superview)
	{
	CGRect theFrame = self.frame;
	theFrame = [inSuperview convertRect:theFrame fromView:self.superview];
	[self removeFromSuperview];
	[inSuperview addSubview:self];
	self.frame = theFrame;
	}
}

@end
