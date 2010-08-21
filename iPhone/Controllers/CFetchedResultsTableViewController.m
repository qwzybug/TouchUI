//
//  CFetchedResultsTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 6/10/09.
//  Copyright 2009 toxicsoftware.com, Inc. All rights reserved.
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

const double kPlaceholderHideShowAnimationDuration = 0.4;

@interface CFetchedResultsTableViewController ()
- (void)updatePlacholder:(BOOL)inAnimated;
@end

#pragma mark -

@implementation CFetchedResultsTableViewController

@synthesize managedObjectContext;
@synthesize fetchRequest;
@synthesize fetchedResultsController;
@synthesize addButtonItem;
@synthesize placeholderView;

- (void)dealloc
{
[fetchRequest release];
fetchRequest = NULL;
fetchedResultsController.delegate = NULL;
[fetchedResultsController release];
fetchedResultsController = NULL;
[addButtonItem release];
addButtonItem = NULL;
[placeholderView release];
placeholderView = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)setEditing:(BOOL)inEditing animated:(BOOL)inAnimated
{
[super setEditing:inEditing animated:inAnimated];
//
addButtonItem.enabled = !inEditing;
}

- (void)setEditing:(BOOL)inEditing
{
[super setEditing:inEditing];
//
addButtonItem.enabled = !inEditing;
}

#pragma mark -

- (void)setFetchRequest:(NSFetchRequest *)inFetchRequest
{
if (fetchRequest != inFetchRequest)
	{
	if (fetchRequest != NULL)
		{
		[fetchRequest release];
		fetchRequest = NULL;
		
		self.fetchedResultsController = NULL;
		}
	//
	if (inFetchRequest != NULL)
		{
		fetchRequest = [inFetchRequest retain];
		[self.fetchedResultsController performFetch:NULL];
		}
		
	[self updatePlacholder:YES];

	[self.tableView reloadData];
	}
}

- (NSFetchedResultsController *)fetchedResultsController
{
if (fetchedResultsController == NULL)
	{
	if (self.fetchRequest)
		{
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:NULL cacheName:NULL];
		fetchedResultsController.delegate = self;
		}
	}
return(fetchedResultsController);
}

- (UIBarButtonItem *)addButtonItem
{
if (addButtonItem == NULL)
	{
	addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	}
return(addButtonItem);
}

- (UIView *)placeholderView
{
if (placeholderView == NULL)
	{
	UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 44 * 3, self.view.bounds.size.width, 44)] autorelease];
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
	[placeholderView release];
	placeholderView = [inPlaceholderView retain];
    }
}

#pragma mark -

- (void)viewDidUnload
{
[super viewDidUnload];
//
fetchedResultsController.delegate = NULL;
[fetchedResultsController release];
fetchedResultsController = NULL;
[addButtonItem release];
addButtonItem = NULL;
[placeholderView release];
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

[self updatePlacholder:NO];

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

- (void)updatePlacholder:(BOOL)inAnimated
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
if (editingStyle == UITableViewCellEditingStyleDelete)
	{
	NSManagedObject *theObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[self.managedObjectContext deleteObject:theObject];
//	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
    }
	
NSError *theError = NULL;
if ([self.managedObjectContext save:&theError] == NO)
	{
	NSLog(@"Error: %@", theError);
	}


if ([self.fetchedResultsController.fetchedObjects count] == 0)
	{
	[self setEditing:NO animated:YES];
	}
	
[self updatePlacholder:YES];
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

[self updatePlacholder:YES];
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
