//
//  CErrorPresenter.m
//  TouchCode
//
//  Created by Jonathan Wight on 3/2/09.
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

#import "CErrorPresenter.h"

#import "UIViewController_Extensions.h"

NSString *ErrorPresenter_ErrorTitleKey = @"error_title";

#pragma mark -

@implementation CErrorPresenter

static CErrorPresenter *gSharedInstance = NULL;

+ (CErrorPresenter *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CErrorPresenter alloc] init];
        });
    return(gSharedInstance);
    }

- (void)presentError:(NSError *)inError
    {
    if ([NSThread isMainThread] == NO)
        {
        [self performSelectorOnMainThread:@selector(presentError:) withObject:inError waitUntilDone:YES];
        return;
        }
//    UIResponder *theResponder = AssertCast_(UIResponder, [UIApplication sharedApplication].keyWindow);
    UIWindow *theWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *theViewController = theWindow.rootViewController;
    theViewController = [theViewController findChildViewControllerThatConformsToProtocol:@protocol(CErrorPresenter)];
    id <CErrorPresenter> thePresenter = (id <CErrorPresenter>)theViewController;
    if (thePresenter)
        {
        [thePresenter presentError:inError];
        }
    else
        {
        NSString *theTitle = NULL;
        theTitle = [inError.userInfo objectForKey:ErrorPresenter_ErrorTitleKey];

        if (theTitle == NULL)
            theTitle = @"Error";

        NSString *theMessage = NULL;
        NSString *theLocalizedDescription = [inError.userInfo objectForKey:NSLocalizedDescriptionKey];
        if (theLocalizedDescription)
            {
            NSMutableString *theMutableMessage = [theLocalizedDescription mutableCopy];
            
            NSString *theRecoverySuggestion = [inError.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
            if (theRecoverySuggestion != NULL)
                {
                [theMutableMessage appendFormat:@"\n%@", theRecoverySuggestion];
                }
                
            theMessage = theMutableMessage;
            }

        if (theMessage == NULL)
            {
            theMessage = inError.localizedDescription;
            }

        NSString *theCancelButtonTitle = @"OK";

        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:theTitle message:theMessage delegate:NULL cancelButtonTitle:theCancelButtonTitle otherButtonTitles:NULL, NULL];
        [theAlert show];
        }
    }

@end

#pragma mark -

@implementation NSError (UIError_ErrorPresenterExtensions)
- (void)present
    {
    [[CErrorPresenter sharedInstance] presentError:self];
    }
@end


