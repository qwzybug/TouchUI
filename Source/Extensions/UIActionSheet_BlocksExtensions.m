//
//  UIActionSheet_BlocksExtensions.m
//  AnythingDB
//
//  Created by Jonathan Wight on 10/18/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "UIActionSheet_BlocksExtensions.h"

#import <objc/runtime.h>

@interface CActionSheetDelegateStandIn : NSObject <UIActionSheetDelegate> {
    NSMutableDictionary *handlersByIndex;
}

@property (readwrite, nonatomic, retain) NSMutableDictionary *handlersByIndex;

@end

#pragma mark -

@interface UIActionSheet ()

@property (readwrite, nonatomic, retain) CActionSheetDelegateStandIn *standIn;

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
