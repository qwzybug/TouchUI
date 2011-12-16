//
//  UIViewController_Extensions.h
//  knotes
//
//  Created by Jonathan Wight on 10/5/11.
//  Copyright (c) 2011 knotes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewController_Extensions)

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion dismissHandler:(void (^)(void))inHandler;
- (void)MY_dismissViewControllerAnimated:(BOOL)flag completion: (void (^)(void))completion;
- (UIViewController *)findChildViewControllerThatConformsToProtocol:(Protocol *)inProtocol;

@end
