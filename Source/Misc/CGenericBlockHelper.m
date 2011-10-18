//
//  CGenericBlockHelper.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/18/11.
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
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 2011 JONATHAN WIGHT OR
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

#import "CGenericBlockHelper.h"

#import <objc/runtime.h>

static void *kGenericBlockHelper;

@implementation CGenericBlockHelper

@synthesize handler;

+ (CGenericBlockHelper *)helperForHandler:(id)inObject selector:(SEL)inSelector
    {
    CGenericBlockHelper *theHelper = objc_getAssociatedObject(inObject, &kGenericBlockHelper);
    if (theHelper == NULL)
        {
        theHelper = [[CGenericBlockHelper alloc] init];
        objc_setAssociatedObject(inObject, &kGenericBlockHelper, theHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        Class theClass = [self class];
        if (class_respondsToSelector(theClass, inSelector) == NO)
            {
            void (^theIMPBlock)(CGenericBlockHelper * _self) = ^(CGenericBlockHelper * _self) {
                if (_self.handler != NULL)
                    {
                    _self.handler();
                    }
                };
            IMP theIMP = imp_implementationWithBlock((__bridge void *)theIMPBlock);
            BOOL theResult = class_addMethod(theClass, inSelector, theIMP, "v:@");
            NSAssert(theResult == YES, @"Could not add method");
            }
        }

    return(theHelper);
    }

@end
