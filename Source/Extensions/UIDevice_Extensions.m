//
//  UIDevice_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/08/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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

#import "UIDevice_Extensions.h"

#import "NSData_DigestExtensions.h"
#import "NSData_Extensions.h"

#import <CommonCrypto/CommonHMAC.h>

#ifndef UNIQUE_IDENTIFIER_KEY
//#warning No unique identifier key defined. Using my own.
#define UNIQUE_IDENTIFIER_KEY @"AF91DE81-790E-4F0F-BD77-7D305922A28F"
#endif

@implementation UIDevice (UIDevice_Extensions)

- (NSString *)obfuscatedUniqueIdentifier
	{
	static NSString *theDigest = NULL;
	if (theDigest == NULL)
		{
		NSData *theKey = [UNIQUE_IDENTIFIER_KEY dataUsingEncoding:NSUTF8StringEncoding];
		NSData *theUniqueIDentifier = [self.uniqueIdentifier dataUsingEncoding:NSUTF8StringEncoding];

		UInt8 theMACBuffer[CC_SHA1_DIGEST_LENGTH];
		CCHmac(kCCHmacAlgSHA1, theKey.bytes, theKey.length, theUniqueIDentifier.bytes, theUniqueIDentifier.length, theMACBuffer);
		
		NSData *theData = [NSData dataWithBytesNoCopy:theMACBuffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:NO];
		theDigest = [theData hexString];
		}
	return(theDigest);
	}

- (NSInteger)numericSystemVersion
	{
	static NSInteger sNumericSystemVersion = -1;
	@synchronized(@"-[UIDevice numericSystemVersion]")
		{
		if (sNumericSystemVersion == -1)
			{
			NSString *theSystemVersion = self.systemVersion;
			NSScanner *theScanner = [NSScanner scannerWithString:theSystemVersion];
			[theScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];

			NSInteger theMajorVersion, theMinorVersion;

			[theScanner scanInteger:&theMajorVersion];
			[theScanner scanString:@"." intoString:NULL];
			[theScanner scanInteger:&theMinorVersion];
			
			sNumericSystemVersion = theMajorVersion * 10000 + theMinorVersion * 100;
			}
		}
	return(sNumericSystemVersion);
	}

@end
