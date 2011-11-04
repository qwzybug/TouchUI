//
//  UIViewController+Extensions.m
//  knotes
//
//  Created by Jonathan Wight on 10/5/11.
//  Copyright (c) 2011 knotes. All rights reserved.
//

#import "UIViewController_Extensions.h"

#import <objc/runtime.h>

static void *kHandlerKey;

@implementation UIViewController (UIViewController_Extensions)

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion dismissHandler:(void (^)(void))inHandler
    {
    objc_setAssociatedObject(viewControllerToPresent, &kHandlerKey, inHandler, OBJC_ASSOCIATION_COPY);

    [self presentViewController:viewControllerToPresent animated:flag completion:completion];    
    }

- (void)MY_dismissViewControllerAnimated:(BOOL)flag completion: (void (^)(void))completion
    {
    UIViewController *thePresentedViewController = self.presentedViewController;
    if (thePresentedViewController == NULL)
        {
        thePresentedViewController = self;
        }
    
    void (^theDismissHandler)(void) = objc_getAssociatedObject(thePresentedViewController, &kHandlerKey);
    
    [self dismissViewControllerAnimated:flag completion:^{
        if (completion)
            {
            completion();
            }
        if (theDismissHandler)
            {
            theDismissHandler();
            objc_setAssociatedObject(thePresentedViewController, &kHandlerKey, NULL, OBJC_ASSOCIATION_COPY);
            }
        }];
    }
    
- (UIViewController *)findChildViewControllerThatConformsToProtocol:(Protocol *)inProtocol
    {
    UIViewController *theViewController = self;
    while (theViewController != NULL)
        {
        if ([theViewController respondsToSelector:@selector(visibleViewController)])
            {
            theViewController = [(id)theViewController visibleViewController];
            }
        else if ([theViewController respondsToSelector:@selector(selectedViewController)])
            {
            theViewController = [(id)theViewController selectedViewController];
            }
        else
            break;
        }
        
    while (theViewController != NULL)
        {
        if ([theViewController conformsToProtocol:inProtocol])
            {
            break;
            }
            
        theViewController = theViewController.parentViewController;
        }
        
    return(theViewController);
    }

@end
