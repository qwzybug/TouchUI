//
//  UIActionSheet_BlocksExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/18/10.
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

#import "UIActionSheet_BlocksExtensions.h"

#import <objc/runtime.h>

@interface CActionSheetDelegateStandIn : NSObject <UIActionSheetDelegate> {
    NSMutableDictionary *handlersByIndex;
}

@property (readwrite, nonatomic, strong) NSMutableDictionary *handlersByIndex;

@end

#pragma mark -

@interface UIActionSheet ()

@property (readwrite, nonatomic, strong) CActionSheetDelegateStandIn *standIn;

@end

#pragma mark -

static void *kUIActionSheet_BlocksExtensions_Standin = "kUIActionSheet_BlocksExtensions_Standin";

@implementation UIActionSheet (UIActionSheet_BlocksExtensions)

- (CActionSheetDelegateStandIn *)standIn
    {
    CActionSheetDelegateStandIn *theStandin = objc_getAssociatedObject(self, kUIActionSheet_BlocksExtensions_Standin);
    if (theStandin == NULL)
        {
        NSAssert(self.delegate == NULL, @"Cannot replace delegate with a standin");
        theStandin = [[CActionSheetDelegateStandIn alloc] init];
        self.delegate = theStandin;
        objc_setAssociatedObject(self, kUIActionSheet_BlocksExtensions_Standin, theStandin, OBJC_ASSOCIATION_RETAIN);
        }
    return(theStandin);
    }

- (void)setStandIn:(CActionSheetDelegateStandIn *)inStandIn
    {
    objc_setAssociatedObject(self, kUIActionSheet_BlocksExtensions_Standin, inStandIn, OBJC_ASSOCIATION_RETAIN);
    }

- (NSUInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))inHandler
    {
    NSUInteger theButtonIndex = [self addButtonWithTitle:title];
    [self.standIn.handlersByIndex setObject:[inHandler copy] forKey:[NSNumber numberWithUnsignedInteger:theButtonIndex]];
    return(theButtonIndex);
    }

@end

#pragma mark -

@implementation CActionSheetDelegateStandIn

@synthesize handlersByIndex;

- (id)init
{
if ((self = [super init]) != NULL)
    {
    handlersByIndex = [[NSMutableDictionary alloc] init];
    }
return(self);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
    {
    void (^theBlock)(void) = [self.handlersByIndex objectForKey:[NSNumber numberWithUnsignedInteger:buttonIndex]];
    if (theBlock)
        {
        theBlock();
        }

    actionSheet.delegate = NULL;
    actionSheet.standIn = NULL;
    }

@end
