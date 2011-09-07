//
//  CFetchedResultsTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 6/10/09.
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

#import "CFetchedResultsTableViewController.h"

#import "NSManagedObjectContext_Extensions.h"

const double kPlaceholderHideShowAnimationDuration = 0.4;

#pragma mark -

@implementation CFetchedResultsTableViewController

@synthesize managedObjectContext;
@synthesize fetchRequest;
@synthesize sectionNameKeypath;
@synthesize fetchedResultsController;
@synthesize placeholderView;
@synthesize tableViewCellClass;

- (void)setFetchRequest:(NSFetchRequest *)inFetchRequest
	{
	if (fetchRequest != inFetchRequest)
		{
        self.fetchedResultsController = NULL;
        fetchRequest = inFetchRequest;
		}
	}

- (NSFetchedResultsController *)fetchedResultsController
	{
	if (fetchedResultsController == NULL)
		{
		if (self.fetchRequest)
			{
            NSParameterAssert(self.fetchRequest != NULL);
            NSParameterAssert(self.managedObjectContext != NULL);
            
			fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:self.sectionNameKeypath cacheName:NULL];
			fetchedResultsController.delegate = self;
			}
		}
	return(fetchedResultsController);
	}

- (UIView *)placeholderView
	{
	if (placeholderView == NULL)
		{
        CGRect theRect = (CGRect){ .size = { .width = self.tableView.bounds.size.width, .height = 44 } };
        theRect.origin.y = 44 * 1 + CGRectGetMaxY(self.tableView.tableHeaderView.frame);
        
        
		UILabel *theLabel = [[UILabel alloc] initWithFrame:theRect];
		theLabel.textAlignment = UITextAlignmentCenter;
		theLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] + 3];
		theLabel.textColor = [UIColor grayColor];
		theLabel.opaque = NO;
		theLabel.backgroundColor = [UIColor clearColor];
		theLabel.text = @"No Rows";
		self.placeholderView = theLabel;
		}
	return(placeholderView);
	}

- (void)setPlaceholderView:(UIView *)inPlaceholderView
	{
	if (placeholderView != inPlaceholderView)
		{
		placeholderView = inPlaceholderView;
		}
	}

#pragma mark -

- (void)viewDidUnload
	{
	[super viewDidUnload];
	//
	fetchedResultsController.delegate = NULL;
	fetchedResultsController = NULL;
	placeholderView = NULL;
	}

- (void)viewWillAppear:(BOOL)animated
	{
	[super viewWillAppear:animated];

	self.fetchedResultsController.delegate = self;

	NSError *theError = NULL;
	if (self.fetchedResultsController && [self.fetchedResultsController performFetch:&theError] == NO)
		{
		NSLog(@"Error: %@", theError);
		}
		
	[self.tableView reloadData];

	[self updatePlaceholder:NO];

	if ([self.fetchedResultsController.fetchedObjects count] == 0)
		{
		[self editButtonItem].enabled = NO;
		}
	else
		{
		[self editButtonItem].enabled = YES;
		}
	}

#pragma mark -

- (IBAction)add:(id)inSender
	{
	}

#pragma mark -

- (void)updatePlaceholder:(BOOL)inAnimated
	{
	if (inAnimated)
		{
		if ([self.fetchedResultsController.fetchedObjects count] == 0)
			{
			if (self.placeholderView.superview != self.tableView)
				{
				self.placeholderView.alpha = 0.0f;
				[self.tableView addSubview:self.placeholderView];
				
				[UIView beginAnimations:@"SHOW_PLACEHOLDER" context:NULL];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDuration:kPlaceholderHideShowAnimationDuration];
				self.placeholderView.alpha = 1.0f;
				[UIView commitAnimations];
				}
			}
		else
			{
			if (self.placeholderView.superview == self.tableView)
				{
				[UIView beginAnimations:@"HIDE_PLACEHOLDER" context:NULL];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDuration:kPlaceholderHideShowAnimationDuration];
				self.placeholderView.alpha = 0.0f;
				[UIView commitAnimations];
				}
			}
		}
	else
		{
		if ([self.fetchedResultsController.fetchedObjects count] == 0)
			{
			if (self.placeholderView.superview != self.tableView)
				{
				[self.tableView addSubview:self.placeholderView];
				self.placeholderView.alpha = 1.0f;
				}
			}
		else
			{
			if (self.placeholderView.superview == self.tableView)
				{
				[self.placeholderView removeFromSuperview];
				}
			}
		}
	}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
	{
	NSInteger theNumberOfSections = [self.fetchedResultsController.sections count];
	if (theNumberOfSections == 0)
		{
		theNumberOfSections = 1;
		}
	return(theNumberOfSections);
	}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
	{
	NSArray *theSections = self.fetchedResultsController.sections;
	NSInteger theNumberOfRows = 0;
	if ([theSections count] > 0)
		{
		id <NSFetchedResultsSectionInfo> theSection = [theSections objectAtIndex:section];
		theNumberOfRows = theSection.numberOfObjects;
		}
	return(theNumberOfRows);
	}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
    if (section < (NSInteger)[self.fetchedResultsController.sections count])
        {
        id <NSFetchedResultsSectionInfo> theSection = [self.fetchedResultsController.sections objectAtIndex:section];
        return(theSection.name);
        }
    else
        {
        return(NULL);
        }
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	UITableViewCell *theCell = [self.tableView dequeueReusableCellWithIdentifier:@"CELL"];
	if (theCell == NULL)
		{
		Class theClass = self.tableViewCellClass ?: [UITableViewCell class];
		theCell = [[theClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
		}
	
	NSManagedObject *theObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	if ([theCell conformsToProtocol:@protocol(CManagedObjectTableViewCellProtocol)])
		{
		[(id <CManagedObjectTableViewCellProtocol>)theCell setManagedObject:theObject];
		}
	else
		{
		theCell.textLabel.text = [theObject description];
		}
	
	return(theCell);
	}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
	{
	if (editingStyle == UITableViewCellEditingStyleDelete)
		{
		NSManagedObject *theObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext performTransaction:^(void) {
            [self.managedObjectContext deleteObject:theObject];
            } error:NULL];
		}   
	else if (editingStyle == UITableViewCellEditingStyleInsert)
		{
		}
		
	if ([self.fetchedResultsController.fetchedObjects count] == 0)
		{
		[self setEditing:NO animated:YES];
		}
		
	[self updatePlaceholder:YES];
	}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
	{
	return(UITableViewCellEditingStyleNone);
	}

#pragma mark -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
	{
	[self.tableView beginUpdates];
	}
  
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
	{
	switch (type)
		{
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
	}
 
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
	{
	switch (type)
		{
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
			withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
	//		[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		}
		
	if ([self.fetchedResultsController.fetchedObjects count] == 0)
		{
		[self editButtonItem].enabled = NO;
		}
	else
		{
		[self editButtonItem].enabled = YES;
		}

	[self updatePlaceholder:YES];
	}
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
	{
	[self.tableView endUpdates];
	}

#pragma mark -

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
	{
	if ([animationID isEqualToString:@"HIDE_PLACEHOLDER"])
		{
		[self.placeholderView removeFromSuperview];
		}
	}

@end
