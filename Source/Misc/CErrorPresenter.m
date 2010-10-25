//
//  CErrorPresenter.m
//  TouchCode
//
//  Created by Jonathan Wight on 3/2/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CErrorPresenter.h"

NSString *ErrorPresenter_ErrorTitleKey = @"error_title";

#pragma mark -


@implementation CErrorPresenter

static CErrorPresenter *gInstance = NULL;

@synthesize delegate;

+ (id)instance
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (void)dealloc
{
[super dealloc];
}


- (void)presentError:(NSError *)inError
{
if ([NSThread isMainThread] == NO)
	{
	[self performSelectorOnMainThread:@selector(presentError:) withObject:inError waitUntilDone:YES];
	return;
	}

if (self.delegate && [self.delegate respondsToSelector:@selector(errorPresenter:shouldPresentError:)] && [self.delegate errorPresenter:self shouldPresentError:inError] == NO)
	return;

NSString *theTitle = NULL;
theTitle = [inError.userInfo objectForKey:ErrorPresenter_ErrorTitleKey];

if (theTitle == NULL)
	theTitle = @"Error";

NSString *theMessage = NULL;
NSString *theLocalizedDescription = [inError.userInfo objectForKey:NSLocalizedDescriptionKey];
if (theLocalizedDescription)
	{
	NSMutableString *theMutableMessage = [[theLocalizedDescription mutableCopy] autorelease];
	
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

UIAlertView *theAlert = [[[UIAlertView alloc] initWithTitle:theTitle message:theMessage delegate:NULL cancelButtonTitle:theCancelButtonTitle otherButtonTitles:NULL, NULL] autorelease];
[theAlert show];
}

@end

#pragma mark -

@implementation UIViewController (UIViewController_ErrorExtensions)

- (void)presentError:(NSError *)inError
{
[[CErrorPresenter instance] presentError:inError];
}

@end
