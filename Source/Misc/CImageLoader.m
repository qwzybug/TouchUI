//
//  CImageLoader.m
//  toxicsoftware.com
//
//  Created by Jonathan Wight on 9/23/11.
//  Copyright (c) 2011 toxicsoftware.com. All rights reserved.
//

#import "CImageLoader.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface CImageLoader ()
@property (readonly, nonatomic, retain) NSDictionary *index;
@end

@implementation CImageLoader

@synthesize index;

static CImageLoader *gSharedInstance = NULL;

+ (CImageLoader *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CImageLoader alloc] init];
        });
    return(gSharedInstance);
    }

- (NSDictionary *)index
    {
    if (index == NULL)
        {
        NSMutableDictionary *theIndex = [NSMutableDictionary dictionary];
        
        NSString *thePattern = [NSString stringWithFormat:@"^(.+?)(?:_(Normal|Selected|Highlighted|Disabled)|(?:_(\\d+(?:,\\d+)*)))*(?:@2x)?$"];
        NSError *theError = NULL;
        NSRegularExpression *theRegex = [[NSRegularExpression alloc] initWithPattern:thePattern options:0 error:&theError];

        NSDirectoryEnumerator *theEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:[NSBundle mainBundle].resourceURL includingPropertiesForKeys:NULL options:0 errorHandler:NULL];
        for (NSURL *theURL in theEnumerator)
            {
            NSString *theType = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)theURL.pathExtension, NULL);
            if (UTTypeConformsTo((__bridge CFStringRef)theType, kUTTypeImage))
                {
                NSString *theString = [theURL.lastPathComponent stringByDeletingPathExtension];
                NSTextCheckingResult *theMatch = [theRegex firstMatchInString:theString options:0 range:(NSRange){ .length = theString.length }];
                
                NSString *theImageName = [theMatch rangeAtIndex:1].location != NSNotFound ? [theString substringWithRange:[theMatch rangeAtIndex:1]] : NULL;
                NSString *theFlags0 = [theMatch rangeAtIndex:2].location != NSNotFound ? [theString substringWithRange:[theMatch rangeAtIndex:2]] : NULL;
                NSString *theFlags1 = [theMatch rangeAtIndex:3].location != NSNotFound ? [theString substringWithRange:[theMatch rangeAtIndex:3]] : NULL;

                NSArray *theFlagComponents0 = [theFlags0 componentsSeparatedByString:@","];
                NSArray *theFlagComponents1 = [theFlags1 componentsSeparatedByString:@","];

                NSArray *theInsets = NULL;
                NSArray *theStates = NULL;
                if (theFlagComponents0.count > 0 && isalpha([[theFlagComponents0 lastObject] characterAtIndex:0]))
                    {
                    theStates = theFlagComponents0;
                    }
                else if (theFlagComponents1.count > 0 && isalpha([[theFlagComponents1 lastObject] characterAtIndex:0]))
                    {
                    theStates = theFlagComponents1;
                    }

                if (theFlagComponents0.count > 0 && isnumber([[theFlagComponents0 lastObject] characterAtIndex:0]))
                    {
                    theInsets = theFlagComponents0;
                    }
                else if (theFlagComponents1.count > 0 && isnumber([[theFlagComponents1 lastObject] characterAtIndex:0]))
                    {
                    theInsets = theFlagComponents1;
                    }

                if (theInsets == NULL && theStates == NULL)
                    {
                    continue;
                    }

    //            NSLog(@"%@ %@ %@", theImageName, theInsets, theStates);

                NSMutableDictionary *theImageDictionary = [theIndex objectForKey:theImageName];
                if (theImageDictionary == NULL)
                    {
                    theImageDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        theImageName, @"name",
                        [NSMutableDictionary dictionary], @"states",
                        NULL];
                    [theIndex setObject:theImageDictionary forKey:theImageName];
                    }

                NSMutableDictionary *theStatesDictionary = [theImageDictionary objectForKey:@"states"];
                
                NSMutableDictionary *theInstanceDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    [theURL lastPathComponent], @"filename",
                    NULL];
                            
                if (theInsets)
                    {
                    UIEdgeInsets theInsetsStruct = {};
                    if (theInsets.count > 0)
                        {
                        theInsetsStruct.top = [[theInsets objectAtIndex:0] floatValue];
                        }
                    if (theInsets.count > 1)
                        {
                        theInsetsStruct.left = [[theInsets objectAtIndex:1] floatValue];
                        }
                    if (theInsets.count > 2)
                        {
                        theInsetsStruct.bottom = [[theInsets objectAtIndex:2] floatValue];
                        }
                    if (theInsets.count > 3)
                        {
                        theInsetsStruct.right = [[theInsets objectAtIndex:3] floatValue];
                        }

                    [theInstanceDictionary setObject:[NSValue valueWithUIEdgeInsets:theInsetsStruct] forKey:@"insets"];
                    }

                UIControlState theControlState = UIControlStateNormal;

                if ([theStates containsObject:@"Highlighted"])
                    {
                    theControlState |= UIControlStateHighlighted;
                    }
                else if ([theStates containsObject:@"Disabled"])
                    {
                    theControlState |= UIControlStateDisabled;
                    }
                else if ([theStates containsObject:@"Selected"])
                    {
                    theControlState |= UIControlStateSelected;
                    }

                [theInstanceDictionary setObject:[NSNumber numberWithInt:theControlState] forKey:@"state"];

    //            if ([theInstancesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state == %@", [NSNumber numberWithInt:theControlState]]].count > 0)
    //                {
    //                NSLog(@"Already contains object with same state!!!");
    //                break;
    //                }

                [theStatesDictionary setObject:theInstanceDictionary forKey:[NSNumber numberWithInt:theControlState]];
                }
            }

        index = theIndex;
        }
    return(index);
    }

- (NSDictionary *)imagesNamed:(NSString *)inName
    {
    NSMutableDictionary *theImages = [NSMutableDictionary dictionary];

    NSString *theImageName = [inName stringByDeletingPathExtension];
    
    NSDictionary *theImageDictionary = [self.index objectForKey:theImageName];
    NSDictionary *theStatesDictionary = [theImageDictionary objectForKey:@"states"];
    for (NSDictionary *theStateDictionary in [theStatesDictionary allValues])
        {
        NSNumber *theState = [theStateDictionary objectForKey:@"state"];
        NSString *theFilename = [theStateDictionary objectForKey:@"filename"];
        UIImage *theImage = [UIImage imageNamed:theFilename];
        NSValue *theInsetsValue = [theStateDictionary objectForKey:@"insets"];
        if (theInsetsValue)
            {
            UIEdgeInsets theInsets = [theInsetsValue UIEdgeInsetsValue];
            theImage = [theImage resizableImageWithCapInsets:theInsets];
            }
        
        [theImages setObject:theImage forKey:theState];
        }
    
    return(theImages);
    }

- (UIImage *)imageNamed:(NSString *)inName state:(UIControlState)inState
    {
    NSDictionary *theImages = [self imagesNamed:inName];
    UIImage *theImage = [theImages objectForKey:[NSNumber numberWithUnsignedInteger:inState]];
    if (theImage == NULL)
        {
        theImage = [theImages objectForKey:[NSNumber numberWithUnsignedInteger:UIControlStateNormal]];
        }
    if (theImages.count == 0)
        {
        theImage = [UIImage imageNamed:inName];
        }
    return(theImage);
    }

- (UIImage *)imageNamed:(NSString *)inName
    {
    return([self imageNamed:inName state:UIControlStateNormal]);
    }


@end

#pragma mark -

@implementation CImageLoader (CImageLoader_ControlExtensions)

- (void)setButtonImages:(UIButton *)inControl withImageNamed:(NSString *)inName
    {
    NSDictionary *theImages = [self imagesNamed:inName];
    NSArray *theStates = [[theImages allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber *theState in theStates)
        {
        UIImage *theImage = [theImages objectForKey:theState];

        [inControl setImage:theImage forState:[theState unsignedIntegerValue]];
        }
    }

- (void)setButtonBackgroundImages:(UIButton *)inControl withImageNamed:(NSString *)inName
    {
    NSDictionary *theImages = [self imagesNamed:inName];
    NSArray *theStates = [[theImages allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber *theState in theStates)
        {
        UIImage *theImage = [theImages objectForKey:theState];

        [inControl setBackgroundImage:theImage forState:[theState unsignedIntegerValue]];
        }
    }


@end
