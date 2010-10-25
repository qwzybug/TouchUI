//
//  UIColor_MoreExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 08/13/2005.
//  Copyright 2005 toxicsoftware.com. All rights reserved.
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

#import "UIColor_MoreExtensions.h"

#import "NSString_Extensions.h"
#import "NSScanner_Extensions.h"

@implementation UIColor (NSColor_MoreExtensions)

+ (id)colorWithSVGString:(NSString *)inString
{
UIColor *theColor = NULL;
//
if ([inString isEqualToString:@"none"])
	return([UIColor clearColor]);
else if ([inString isEqualToString:@"red"])
	return([UIColor redColor]);
else if ([inString isEqualToString:@"blue"])
	return([UIColor blueColor]);
else if ([inString isEqualToString:@"yellow"])
	return([UIColor yellowColor]);
else if ([inString isEqualToString:@"green"])
	return([UIColor greenColor]);
//
NSScanner *theScanner = [NSScanner scannerWithString:inString];
[theScanner setCharactersToBeSkipped:NULL];
if ([theScanner scanString:@"rgb" intoString:NULL] == YES)
	{
	if ([theScanner scanString:@"(" intoString:NULL] == NO)
		[NSException raise:NSGenericException format:@"Unable to parse color."];
	[theScanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	CGFloat theChannels[4] = { 0, 0, 0, 255 };
	BOOL thePercentageBasedFlag = NO;

	for (int N = 0; N != 4; ++N)
		{
		if ([theScanner scanCGFloat:&theChannels[N]] == NO)
			[NSException raise:NSGenericException format:@"Unable to parse color."];
		if ([theScanner scanString:@"%" intoString:NULL])
			thePercentageBasedFlag = YES;

		if (thePercentageBasedFlag && N != 3)
			theChannels[3] = 100.0f;

		if ([theScanner scanString:@"," intoString:NULL] == NO)
			{
			if ([theScanner scanString:@")" intoString:NULL] == NO)
				[NSException raise:NSGenericException format:@"Unable to parse color."];
			break;
			}
		if (N == 3 && [theScanner scanString:@")" intoString:NULL] == NO)
			[NSException raise:NSGenericException format:@"Unable to parse color."];
		}

	if (thePercentageBasedFlag)
		theColor = [UIColor colorWithRed:(CGFloat)theChannels[0] / 100.0f green:(CGFloat)theChannels[1] / 100.0f blue:(CGFloat)theChannels[2] / 100.0f alpha:(CGFloat)theChannels[3] / 100.0f];
	else
		theColor = [UIColor colorWithRed:(CGFloat)theChannels[0] / 255.0f green:(CGFloat)theChannels[1] / 255.0f blue:(CGFloat)theChannels[2] / 255.0f alpha:(CGFloat)theChannels[3] / 255.0f];
	}
else if ([theScanner scanString:@"url" intoString:NULL] == YES)
	{
	/*
	if ([theScanner scanString:@"(" intoString:NULL] == NO)
		[NSException raise:NSGenericException format:@"Unable to parse color."];
	// Currently only anchor URLs are recognised
	if ([theScanner scanString:@"#" intoString:NULL] == NO)
		[NSException raise:NSGenericException format:@"Unable to parse color."];
		
	NSCharacterSet *theCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@")"] invertedSet];
	
	if ([theScanner scanCharactersFromSet:theCharaterSet intoString:theString]
		[NSException raise:NSGenericException format:@"Unable to parse color."];
	
	*/
	}
else
	{
	theColor = [self colorWithHTMLString:inString];
	}
	
return(theColor);
}


+ (id)colorWithHTMLString:(NSString *)inHTMLString
{
NSString *theHTMLString = [inHTMLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

if ([theHTMLString isEqual:@"none"])
	return(NULL);
else if ([theHTMLString isEqual:@"black"])
//	return([self blackColor]);
	return([self colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]);
else if ([theHTMLString isEqual:@"blue"])
	return([self colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]);
else if ([theHTMLString isEqual:@"red"])
	return([self colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]);
else if ([theHTMLString characterAtIndex:0] == '#')
	{
	theHTMLString = [theHTMLString substringFromIndex:1];
	if ([theHTMLString length] == 3)
		{
		NSString *theRedHex = [theHTMLString substringWithRange:NSMakeRange(0, 1)];
		CGFloat theRed = (CGFloat)[theRedHex asLongFromHex] / 15.0f;
		NSString *theGreenHex = [theHTMLString substringWithRange:NSMakeRange(1, 1)];
		CGFloat theGreen = (CGFloat)[theGreenHex asLongFromHex] / 15.0f;
		NSString *theBlueHex = [theHTMLString substringWithRange:NSMakeRange(2, 1)];
		CGFloat theBlue = (CGFloat)[theBlueHex asLongFromHex] / 15.0f;
		return([self colorWithRed:theRed green:theGreen blue:theBlue alpha:1.0f]);
		}
	else if ([theHTMLString length] == 6)
		{
		NSString *theRedHex = [theHTMLString substringWithRange:NSMakeRange(0, 2)];
		CGFloat theRed = (CGFloat)[theRedHex asLongFromHex] / 255.0f;
		NSString *theGreenHex = [theHTMLString substringWithRange:NSMakeRange(2, 2)];
		CGFloat theGreen = (CGFloat)[theGreenHex asLongFromHex] / 255.0f;
		NSString *theBlueHex = [theHTMLString substringWithRange:NSMakeRange(4, 2)];
		CGFloat theBlue = (CGFloat)[theBlueHex asLongFromHex] / 255.0f;
		return([self colorWithRed:theRed green:theGreen blue:theBlue alpha:1.0f]);
		}
	else
		return(NULL);
	}
else 
	return(NULL);
}



@end
