//
//  CTemplateTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/4/09.
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

#import "CTemplateTableViewController.h"

#import "CTrivialTemplate.h"
#import "UITableViewCell_Extensions.h"

//static UITableViewCellSelectionStyle UITableViewCellSelectionStyleForString(NSString *inString);
static UITableViewCellStyle UITableViewCellStyleForString(NSString *inString);

@interface CTemplateTableViewController ()
@property (readwrite, nonatomic, retain) NSArray *sections;
@property (readwrite, nonatomic, retain) NSMutableDictionary *heightsForRows;
@property (readwrite, nonatomic, retain) NSMutableDictionary *cellsByRow;

- (NSArray *)processTemplate;
- (NSDictionary *)settingsForRowAtIndexPath:(NSIndexPath *)inIndexPath;
@end

#pragma mark -

@implementation CTemplateTableViewController

@synthesize templateFilePath;
@synthesize heightsForRows;
@synthesize cellsByRow;
@synthesize sections;

- (id)init
	{
	if ((self = [self initWithNibName:NULL bundle:NULL]) != NULL)
		{
		}
	return (self);
	}

- (id)initWithNibName:(NSString *)inNibName bundle:(NSBundle *)inBundle
	{
	if ((self = [super initWithNibName:inNibName bundle:inBundle]) != NULL)
		{
		self.initialStyle = UITableViewStyleGrouped;
		if (inNibName != NULL)
			self.templateFilePath = [[NSBundle mainBundle] pathForResource:inNibName ofType:@"plist"];
		else
			self.templateFilePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"plist"];
		}
	return (self);
	}


- (void)awakeFromNib
	{
	self.initialStyle = UITableViewStyleGrouped;
	if (self.templateFilePath == NULL)
		{
		self.templateFilePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"plist"];
		}
	}

#pragma mark -

- (NSDictionary *)templateDictionary
	{
	NSAssert(self.templateFilePath.length > 0, @"No template path");
	NSDictionary *theTemplateDictionary = [[NSDictionary alloc] initWithContentsOfFile:self.templateFilePath];
	return (theTemplateDictionary);
	}

- (NSArray *)sections
	{
	if (sections == NULL)
		{
		sections = [self processTemplate];
		}
	return (sections);
	}

#pragma mark -

- (void)reload
	{
	self.sections = NULL;
	self.heightsForRows = NULL;
	self.cellsByRow = NULL;
	//
	[self.tableView reloadData];
	}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
	{
	return ([self.sections count]);
	}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
	{
	NSDictionary *theSection = (self.sections)[section];
	return ([theSection[@"rows"] count]);
	}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
	{
	NSDictionary *theSection = (self.sections)[section];
	NSDictionary *theSectionTemplate = theSection[@"template"];
	return (theSectionTemplate[@"title"]);
	}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	UITableViewCell *theCell = NULL;

	if (self.cellsByRow && (self.cellsByRow)[indexPath])
		{
		theCell = (self.cellsByRow)[indexPath];
		if (theCell)
			return (theCell);
		}

	NSDictionary *theSection = (self.sections)[indexPath.section];
	NSDictionary *theRow = theSection[@"rows"][indexPath.row];

	NSString *theClassName = theRow[@"class"];
	Class theClass = [UITableViewCell class];
	if (theClassName.length > 0)
		{
		theClass = NSClassFromString(theClassName);
		}

	NSString *theReuseIdentifier = theRow[@"reuseIdentifier"];
	if ([theReuseIdentifier length] == 0)
		theReuseIdentifier = NULL;

	if (theReuseIdentifier)
		{
		theCell = [self.tableView dequeueReusableCellWithIdentifier:theReuseIdentifier];
		}

	// ####
	if (theCell == NULL)
		{
		NSString *theStyleName = theRow[@"style"];
		if (theStyleName != NULL)
			{
			UITableViewCellStyle theTableViewCellStyle = UITableViewCellStyleForString(theStyleName);
			theCell = [[theClass alloc] initWithStyle:theTableViewCellStyle reuseIdentifier:theReuseIdentifier];
			}
		else
			{
			theCell = [[theClass alloc] initWithReuseIdentifier:theReuseIdentifier];
			}

		NSString *theOutletName = theRow[@"outlet"];
		if (theOutletName)
			{
			[self setValue:theCell forKey:theOutletName];
			}
		}

	NSString *theActionString = theRow[@"action"];
	SEL theAction = NSSelectorFromString(theActionString);
	if (theAction)
		{
// TODO
//		if ([theCell respondsToSelector:@selector(setAction:)])
//			[(id)theCell setAction:theAction];
		}


	NSString *theTargetPath = theRow[@"targetPath"];
	if (theTargetPath)
		{
		id theTarget = [self valueForKeyPath:theTargetPath];
		[theCell setValue:theTarget forKey:@"target"];
		}

	// ####
	NSDictionary *theSettingsDictionary = [self settingsForRowAtIndexPath:indexPath];
	for (NSString *theKey in theSettingsDictionary)
		{
		@try
			{
			id theValue = theSettingsDictionary[theKey];
			[theCell setValue:theValue forKeyPath:theKey];
			}

		@catch (NSException *e)
			{
			NSLog(@"Error: %@", e);
			}
		}

	[theCell sizeToFit];

	if ([theCell conformsToProtocol:@protocol(CDynamicCell)])
		{
		id <CDynamicCell> theDynamicCell = (id <CDynamicCell>)theCell;

		theDynamicCell.delegate = self;
		}

	if (!self.cellsByRow)
		self.cellsByRow = [NSMutableDictionary dictionary];

	(self.cellsByRow)[indexPath] = theCell;

	return (theCell);
	}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	CGFloat theHeight = 44;
	NSNumber *theHeightValue = (self.heightsForRows)[indexPath];
	if (theHeightValue == NULL)
		{
		UITableViewCell *theCell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
		if (theCell)
			{
			CGSize theSize = [theCell sizeThatFits:CGSizeMake(320, 44)];

			theHeight = theSize.height;
			theHeightValue = [NSNumber numberWithDouble:theHeight];
			if (self.heightsForRows == NULL)
				self.heightsForRows = [NSMutableDictionary dictionary];
			(self.heightsForRows)[indexPath] = theHeightValue;
			}
		}
	else
		{
		theHeight = (CGFloat)[theHeightValue doubleValue];
		}

	return (theHeight);
	}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
	{
	NSDictionary *theSection = (self.sections)[indexPath.section];
	NSDictionary *theRow = theSection[@"rows"][indexPath.row];

	NSString *theActionString = theRow[@"action"];
	SEL theAction = NSSelectorFromString(theActionString);

	id theTarget = NULL;
	NSString *theTargetPath = theRow[@"targetPath"];
	if (theTargetPath)
		{
		theTarget = [self valueForKeyPath:theTargetPath];
		if (theAction && theTarget && [theTarget respondsToSelector:theAction])
			{
			[theTarget performSelector:theAction withObject:self];
			return;
			}
		}

	NSString *thePushControllerName = theRow[@"pushControllerName"];
	Class thePushControllerClass = NSClassFromString(thePushControllerName);
	if (thePushControllerClass)
		{
		UIViewController *theController = [[thePushControllerClass alloc] init];
		[self.navigationController pushViewController:theController animated:YES];
		}
	}

#pragma mark -

- (NSArray *)processTemplate
	{
	NSMutableArray *theSections = [NSMutableArray array];
	//
	for (NSDictionary *theSectionDictionary in (self.templateDictionary)[@"sections"])
		{
		NSMutableArray *theRows = [NSMutableArray array];

		for (NSDictionary *theRowDictionary in theSectionDictionary[@"rows"])
			{
			NSString *theHiddenPredicateString = theRowDictionary[@"hiddenPredicate"];

			if (theHiddenPredicateString)
				{
				NSPredicate *thePredicate = [NSPredicate predicateWithFormat:theHiddenPredicateString];
				if ([thePredicate evaluateWithObject:self])
					continue;
				}

			[theRows addObject:theRowDictionary];
			}

		if (theRows.count > 0)
			{
			NSDictionary *theSection = @{@"template": theSectionDictionary,
			                            @"rows": theRows};

			[theSections addObject:theSection];
			}
		}

	return (theSections);
	}


- (NSDictionary *)settingsForRowAtIndexPath:(NSIndexPath *)inIndexPath
	{
	NSDictionary *theSection = (self.sections)[inIndexPath.section];
	NSDictionary *theRow = theSection[@"rows"][inIndexPath.row];

	NSArray *theSettings = theRow[@"settings"];

	NSMutableDictionary *theSettingsDictionary = [NSMutableDictionary dictionary];

	for (NSDictionary *theSetting in theSettings)
		{
		NSString *theDestinationPath = theSetting[@"destinationPath"];

		BOOL theDontUseAltValuesFlag = YES;

		NSString *thePredicateString = theSetting[@"predicate"];
		if (thePredicateString)
			{
			NSPredicate *thePredicate = [NSPredicate predicateWithFormat:thePredicateString];
			theDontUseAltValuesFlag = [thePredicate evaluateWithObject:self];
			}

		NSString *theValueKey = theDontUseAltValuesFlag ? @"value" : @"altValue";
		NSString *theValuePathKey = theDontUseAltValuesFlag ? @"valuePath" : @"altValuePath";
		NSString *theValueFormatKey = theDontUseAltValuesFlag ? @"valueFormat" : @"altValueFormat";
		NSString *theValuePredicateKey = theDontUseAltValuesFlag ? @"valuePredicate" : @"altValuePredicate";
		NSString *theValueTransformerKey = @"valueTransformer";

		id theValue = theSetting[theValueKey];

		if (theValue == NULL)
			{
			NSString *theValuePath = theSetting[theValuePathKey];
			if (theValuePath)
				theValue = [self valueForKeyPath:theValuePath];
			}

		if (theValue == NULL)
			{
			NSString *theValueFormat = theSetting[theValueFormatKey];
			if (theValueFormat)
				{
				CTrivialTemplate *theTemplate = [[CTrivialTemplate alloc] initWithTemplate:theValueFormat];
				NSError *theError = NULL;
				theValue = [theTemplate transform:(NSDictionary *)self error:&theError];
				}
			}

		if (theValue == NULL)
			{
			NSString *theValuePredicate = theSetting[theValuePredicateKey];
			if (theValuePredicate)
				{
				NSPredicate *thePredicate = [NSPredicate predicateWithFormat:theValuePredicate];
				theValue = @([thePredicate evaluateWithObject:self]);
				}
			}

		NSString *theTransformerName = theSetting[theValueTransformerKey];
		NSValueTransformer *theValueTransformer = [NSValueTransformer valueTransformerForName:theTransformerName];
		if (theValueTransformer)
			{
			theValue = [theValueTransformer transformedValue:theValue];
			}

		if (theDestinationPath && theValue)
			theSettingsDictionary[theDestinationPath] = theValue;
		}

	return (theSettingsDictionary);
	}

- (void)dynamicCellDidResize:(id <CDynamicCell>)inCell;
	{
	self.heightsForRows = NULL;

	[self.tableView reloadData];

	//UITableViewCell *theCell = (UITableViewCell *)inCell;
	//NSIndexPath *theIndexPath = [self.tableView indexPathForCell:theCell];
	//if (theI
	//CGSize theSize = [theCell sizeThatFits:CGSizeMake(320, 44)];
	//
	//NSValue *theHeightValue = [NSNumber numberWithDouble:theSize.height];
	//if (self.heightsForRows == NULL)
	//	self.heightsForRows = [NSMutableDictionary dictionary];
	//[self.heightsForRows setObject:theHeightValue forKey:theIndexPath];

	}

@end

#pragma mark -

//static UITableViewCellSelectionStyle UITableViewCellSelectionStyleForString(NSString *inString)
//{
//if ([inString isEqualToString:@"UITableViewCellSelectionStyleNone"])
//	return(UITableViewCellSelectionStyleNone);
//else if ([inString isEqualToString:@"UITableViewCellSelectionStyleBlue"])
//	return(UITableViewCellSelectionStyleBlue);
//else if ([inString isEqualToString:@"UITableViewCellSelectionStyleGray"])
//	return(UITableViewCellSelectionStyleGray);
//else
//	return(UITableViewCellSelectionStyleNone);
//}


static UITableViewCellStyle UITableViewCellStyleForString(NSString *inString)
	{
	if ([inString isEqualToString:@"UITableViewCellStyleDefault"])
		return (UITableViewCellStyleDefault);
	else if ([inString isEqualToString:@"UITableViewCellStyleValue1"])
		return (UITableViewCellStyleValue1);
	else if ([inString isEqualToString:@"UITableViewCellStyleValue2"])
		return (UITableViewCellStyleValue2);
	else if ([inString isEqualToString:@"UITableViewCellStyleSubtitle"])
		return (UITableViewCellStyleSubtitle);
	else
		return (UITableViewCellStyleDefault);
	}
