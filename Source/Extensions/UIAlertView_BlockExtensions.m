//
//  UIAlertView+BlockExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/1/11.
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

#import "UIAlertView_BlockExtensions.h"

#import <objc/runtime.h>

@interface CAlertViewBlockHelper : NSObject <UIAlertViewDelegate>
@property (readwrite, nonatomic, copy) void (^buttonHandler)(NSInteger buttonIndex);
@property (readwrite, nonatomic, copy) void (^cancelHandler)(void);
@end

#pragma mark -

static void *kCAlertViewBlockHelperKey;

@implementation UIAlertView (BlockExtensions)

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
    {
    if ((self = [self initWithTitle:title message:message delegate:NULL cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, NULL]) != NULL)
        {
        if (otherButtonTitles)
            {
            va_list theArgs;
            va_start(theArgs, otherButtonTitles);
            id theArg = NULL;
            while ((theArg = va_arg(theArgs, id)) != NULL)
                {
                [self addButtonWithTitle:theArg];
                }
            va_end(theArgs);
            }
        }
    return(self);
    }

- (void (^)(NSInteger))buttonHandler
    {
    CAlertViewBlockHelper *theHelper = objc_getAssociatedObject(self, &kCAlertViewBlockHelperKey);
    return(theHelper.buttonHandler);
    }

- (void)setButtonHandler:(void (^)(NSInteger))buttonHandler
    {
    CAlertViewBlockHelper *theHelper = objc_getAssociatedObject(self, &kCAlertViewBlockHelperKey);
    if (theHelper == NULL)
        {
        theHelper = [[CAlertViewBlockHelper alloc] init];
        objc_setAssociatedObject(self, &kCAlertViewBlockHelperKey, theHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = theHelper;
        }
    theHelper.buttonHandler = buttonHandler;
    }

- (void (^)(void))cancelHandler
    {
    CAlertViewBlockHelper *theHelper = objc_getAssociatedObject(self, &kCAlertViewBlockHelperKey);
    return(theHelper.cancelHandler);
    }

- (void)setCancelHandler:(void (^)(void))cancelHandler
    {
    CAlertViewBlockHelper *theHelper = objc_getAssociatedObject(self, &kCAlertViewBlockHelperKey);
    if (theHelper == NULL)
        {
        theHelper = [[CAlertViewBlockHelper alloc] init];
        objc_setAssociatedObject(self, &kCAlertViewBlockHelperKey, theHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = theHelper;
        }
    theHelper.cancelHandler = cancelHandler;
    }

@end

#pragma mark -

@implementation CAlertViewBlockHelper

@synthesize buttonHandler;
@synthesize cancelHandler;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
    {
    if (self.buttonHandler)
        {
        self.buttonHandler(buttonIndex);
        }
    }

- (void)alertViewCancel:(UIAlertView *)alertView;
    {
    if (self.cancelHandler)
        {
        self.cancelHandler();
        }
    }

@end

