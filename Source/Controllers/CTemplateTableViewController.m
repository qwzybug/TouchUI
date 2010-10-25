//
//  CTemplateTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/4/09.
//  Copyright 2009 Small Society. All rights reserved.
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
return(self);
}

- (void)dealloc
{
self.templateFilePath = NULL;
self.sections = NULL;
self.heightsForRows = NULL;
self.cellsByRow = NULL;
//
[super dealloc];
}

- (void)awakeFromNib
{
self.initialStyle = UITableViewStyleGrouped;
self.templateFilePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"plist"];
}

#pragma mark -

- (NSDictionary *)templateDictionary
{
return([[[NSDictionary alloc] initWithContentsOfFile:self.templateFilePath] autorelease]);
}

- (NSArray *)sections
{
if (sections == NULL)
	{
	sections = [[self processTemplate] retain];
	}
return(sections);
}

- (void)setSections:(NSArray *)inSections
{
if (sections != inSections)
	{
	[sections release];
	sections = [inSections retain];
    }
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
return([self.sections count]);
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
NSDictionary *theSection = [self.sections objectAtIndex:section];
return([[theSection objectForKey:@"rows"] count]);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
NSDictionary *theSection = [self.sections objectAtIndex:section];
NSDictionary *theSectionTemplate = [theSection objectForKey:@"template"];
return([theSectionTemplate objectForKey:@"title"]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = NULL;

if (self.cellsByRow && [self.cellsByRow objectForKey:indexPath])
	{
	theCell = [self.cellsByRow objectForKey:indexPath];
	if (theCell)
		return(theCell);
	}

NSDictionary *theSection = [self.sections objectAtIndex:indexPath.section];
NSDictionary *theRow = [[theSection objectForKey:@"rows"] objectAtIndex:indexPath.row];

NSString *theClassName = [theRow objectForKey:@"class"];
Class theClass = NSClassFromString(theClassName);

NSString *theReuseIdentifier = [theRow objectForKey:@"reuseIdentifier"];
if ([theReuseIdentifier length] == 0)
	theReuseIdentifier = NULL;

if (theReuseIdentifier)
	{
	theCell = [self.tableView dequeueReusableCellWithIdentifier:theReuseIdentifier];
	}

// ####
if (theCell == NULL)
	{
	NSString *theStyleName = [theRow objectForKey:@"style"];
	if (theStyleName != NULL)
		{
		UITableViewCellStyle theTableViewCellStyle = UITableViewCellStyleForString(theStyleName);
		theCell = [[[theClass alloc] initWithStyle:theTableViewCellStyle reuseIdentifier:theReuseIdentifier] autorelease];
		}
	else
		{
		theCell = [[[theClass alloc] initWithReuseIdentifier:theReuseIdentifier] autorelease];
		}
	}

NSString *theActionString = [theRow objectForKey:@"action"];
SEL theAction = NSSelectorFromString(theActionString);
if (theAction)
	{
	if ([theCell respondsToSelector:@selector(setAction:)])
		[(id)theCell setAction:theAction];
	}

NSString *theTargetPath = [theRow objectForKey:@"targetPath"];
if (theTargetPath)
	{
	id theTarget = [self valueForKeyPath:theTargetPath];
	[theCell setValue:theTarget forKey:@"target"];
	}

// ####
NSDictionary *theSettingsDictionary = [self settingsForRowAtIndexPath:indexPath];
for (NSString *theKey in theSettingsDictionary)
	{
	id theValue = [theSettingsDictionary objectForKey:theKey];
	[theCell setValue:theValue forKeyPath:theKey];
	}

[theCell sizeToFit];

if ([theCell conformsToProtocol:@protocol(CDynamicCell)])
	{
	id <CDynamicCell> theDynamicCell = (id <CDynamicCell>)theCell;

	theDynamicCell.delegate = self;
	}

if (!self.cellsByRow)
	self.cellsByRow = [NSMutableDictionary dictionary];

[self.cellsByRow setObject:theCell forKey:indexPath];

return(theCell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
CGFloat theHeight = 44;
NSNumber *theHeightValue = [self.heightsForRows objectForKey:indexPath];
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
		[self.heightsForRows setObject:theHeightValue forKey:indexPath];
		}
	}
else
	{
	theHeight = (CGFloat)[theHeightValue doubleValue];
	}

return(theHeight);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
NSDictionary *theSection = [self.sections objectAtIndex:indexPath.section];
NSDictionary *theRow = [[theSection objectForKey:@"rows"] objectAtIndex:indexPath.row];

NSString *theActionString = [theRow objectForKey:@"action"];
SEL theAction = NSSelectorFromString(theActionString);

id theTarget = NULL;
NSString *theTargetPath = [theRow objectForKey:@"targetPath"];
if (theTargetPath)
	{
	theTarget = [self valueForKeyPath:theTargetPath];
	if (theAction && theTarget && [theTarget respondsToSelector:theAction])
		{
		[theTarget performSelector:theAction withObject:self];
		return;
		}
	}

NSString *thePushControllerName = [theRow objectForKey:@"pushControllerName"];
Class thePushControllerClass = NSClassFromString(thePushControllerName);
if (thePushControllerClass)
	{
	UIViewController *theController = [[[thePushControllerClass alloc] init] autorelease];
	[self.navigationController pushViewController:theController animated:YES];
	}
}

#pragma mark -

- (NSArray *)processTemplate
{
NSMutableArray *theSections = [NSMutableArray array];
//
for (NSDictionary *theSectionDictionary in [self.templateDictionary objectForKey:@"sections"])
	{
	NSMutableArray *theRows = [NSMutableArray array];

	for (NSDictionary *theRowDictionary in [theSectionDictionary objectForKey:@"rows"])
		{
		NSString *theHiddenPredicateString = [theRowDictionary objectForKey:@"hiddenPredicate"];

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
		NSDictionary *theSection = [NSDictionary dictionaryWithObjectsAndKeys:
			theSectionDictionary, @"template",
			theRows, @"rows",
			NULL];

		[theSections addObject:theSection];
		}
	}

return(theSections);
}


- (NSDictionary *)settingsForRowAtIndexPath:(NSIndexPath *)inIndexPath
{
NSDictionary *theSection = [self.sections objectAtIndex:inIndexPath.section];
NSDictionary *theRow = [[theSection objectForKey:@"rows"] objectAtIndex:inIndexPath.row];

NSArray *theSettings = [theRow objectForKey:@"settings"];

NSMutableDictionary *theSettingsDictionary = [NSMutableDictionary dictionary];

for (NSDictionary *theSetting in theSettings)
	{
	NSString *theDestinationPath = [theSetting objectForKey:@"destinationPath"];

	BOOL theDontUseAltValuesFlag = YES;

	NSString *thePredicateString = [theSetting objectForKey:@"predicate"];
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

	id theValue = [theSetting objectForKey:theValueKey];

	if (theValue == NULL)
		{
		NSString *theValuePath = [theSetting objectForKey:theValuePathKey];
		if (theValuePath)
			theValue = [self valueForKeyPath:theValuePath];
		}

	if (theValue == NULL)
		{
		NSString *theValueFormat = [theSetting objectForKey:theValueFormatKey];
		if (theValueFormat)
			{
			CTrivialTemplate *theTemplate = [[[CTrivialTemplate alloc] initWithTemplate:theValueFormat] autorelease];
			NSError *theError = NULL;
			theValue = [theTemplate transform:(NSDictionary *)self error:&theError];
			}
		}

	if (theValue == NULL)
		{
		NSString *theValuePredicate = [theSetting objectForKey:theValuePredicateKey];
		if (theValuePredicate)
			{
			NSPredicate *thePredicate = [NSPredicate predicateWithFormat:theValuePredicate];
			theValue = [NSNumber numberWithBool:[thePredicate evaluateWithObject:self]];
			}
		}

	NSString *theTransformerName = [theSetting objectForKey:theValueTransformerKey];
	NSValueTransformer *theValueTransformer = [NSValueTransformer valueTransformerForName:theTransformerName];
	if (theValueTransformer)
		{
		theValue = [theValueTransformer transformedValue:theValue];
		}

	if (theDestinationPath && theValue)
		[theSettingsDictionary setObject:theValue forKey:theDestinationPath];
	}

return(theSettingsDictionary);
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
	return(UITableViewCellStyleDefault);
else if ([inString isEqualToString:@"UITableViewCellStyleValue1"])
	return(UITableViewCellStyleValue1);
else if ([inString isEqualToString:@"UITableViewCellStyleValue2"])
	return(UITableViewCellStyleValue2);
else if ([inString isEqualToString:@"UITableViewCellStyleSubtitle"])
	return(UITableViewCellStyleSubtitle);
else
	return(UITableViewCellStyleDefault);
}
