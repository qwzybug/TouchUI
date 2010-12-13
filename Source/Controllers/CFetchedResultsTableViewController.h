//
//  CFetchedResultsTableViewController.h
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

#import "CTableViewController.h"

#import <CoreData/CoreData.h>

@interface CFetchedResultsTableViewController : CTableViewController <NSFetchedResultsControllerDelegate> {
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	NSFetchedResultsController *fetchedResultsController;
	UIView *placeholderView;
	Class tableViewCellClass;
}

@property (readwrite, nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (readwrite, nonatomic, retain) NSFetchRequest *fetchRequest;
@property (readwrite, nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (readwrite, nonatomic, retain) UIView *placeholderView;
@property (readwrite, nonatomic, assign) Class tableViewCellClass;

- (IBAction)add:(id)inSender;

- (void)updatePlaceholder:(BOOL)inAnimated;

@end

#pragma mark -

@protocol CManagedObjectTableViewCellProtocol

@property (readwrite, nonatomic, retain) NSManagedObject *managedObject;

@end

