//
//  CTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 2/25/09.
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

#import "CTableViewController.h"

// UITableViewController
// Creates a table view with the correct dimensions and autoresizing, setting the datasource and delegate to self.
// In -viewWillAppear:, it reloads the table's data if it's empty. Otherwise, it deselects all rows (with or without animation).
// In -viewDidAppear:, it flashes the table's scroll indicators.
// Implements -setEditing:animated: to toggle the editing state of the table.

static void *kTableHeaderViewFrameKey;
static void *kTableFooterViewFrameKey;

@interface CTableViewController ()
@property (readwrite, nonatomic, assign) BOOL observingTableHeaderFrame;
@property (readwrite, nonatomic, assign) BOOL observingTableFooterFrame;
@end

#pragma mark -

@implementation CTableViewController

@synthesize tableView;
@synthesize initialStyle;
@synthesize clearsSelectionOnViewWillAppear;
@synthesize addButtonItem;
@synthesize tableBackgroundView;
@synthesize tableHeaderView;
@synthesize tableFooterView;

@synthesize observingTableHeaderFrame;
@synthesize observingTableFooterFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
    {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) != NULL)
        {
        initialStyle = UITableViewStylePlain;
        clearsSelectionOnViewWillAppear = YES;
        }
    return(self);
    }
  
#pragma mark -    

- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    }

- (void)loadView
    {
    [super loadView];
    //
    if (self.view == NULL)
        {
        CGRect theViewFrame = [[UIScreen mainScreen] applicationFrame];
        UIView *theView = [[UITableView alloc] initWithFrame:theViewFrame];
        theView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //
        self.view = theView;
        }

    if (self.tableView == NULL)
        {
        if ([self.view isKindOfClass:[UITableView class]])
            {
            self.tableView = (UITableView *)self.view;
            }
        else
            {
            CGRect theViewFrame = self.view.bounds;
            UITableView *theTableView = [[UITableView alloc] initWithFrame:theViewFrame style:self.initialStyle];
            theTableView.delegate = self;
            theTableView.dataSource = self;
            theTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            //
            [self.view addSubview:theTableView];
            self.tableView = theTableView;
            }
        }
    }

- (void)viewDidLoad
    {
    [super viewDidLoad];

    if (self.tableBackgroundView != NULL)
        {
        self.tableView.backgroundView = self.tableBackgroundView;
        }

    if (self.tableHeaderView != NULL)
        {
        self.tableView.tableHeaderView = self.tableHeaderView;
        }

    if (self.tableFooterView != NULL)
        {
        self.tableView.tableFooterView = self.tableFooterView;
        }
    }

- (void)viewWillUnload
    {
    [super viewWillUnload];
    //
    self.tableView = NULL;    
    self.tableBackgroundView = NULL;
    self.tableHeaderView = NULL;
    self.tableFooterView = NULL;
    }

- (void)viewWillAppear:(BOOL)inAnimated
    {
    [super viewWillAppear:inAnimated];
    //
    [self.tableView reloadData];
    //
    if (self.clearsSelectionOnViewWillAppear == YES)
        {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:inAnimated];
        }

    if (self.tableHeaderView != NULL && self.observingTableHeaderFrame == NO)
        {
        self.observingTableHeaderFrame = YES;
        [self addObserver:self forKeyPath:@"tableView.tableHeaderView.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&kTableHeaderViewFrameKey];
        }

    if (self.tableFooterView != NULL && self.observingTableFooterFrame == NO)
        {
        self.observingTableFooterFrame = YES;
        [self addObserver:self forKeyPath:@"tableView.tableFooterView.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&kTableFooterViewFrameKey];
        }
    }

- (void)viewDidAppear:(BOOL)inAnimated
    {
    [super viewDidAppear:inAnimated];
    //
    [self.tableView flashScrollIndicators];
    }

- (void)viewWillDisappear:(BOOL)animated
    {
    [super viewDidDisappear:animated];
    //
    if (self.observingTableHeaderFrame == YES)
        {
        self.observingTableHeaderFrame = NO;
        [self removeObserver:self forKeyPath:@"tableView.tableHeaderView.frame" context:&kTableHeaderViewFrameKey];
        }

    if (self.observingTableFooterFrame == YES)
        {
        self.observingTableFooterFrame = NO;
        [self removeObserver:self forKeyPath:@"tableView.tableFooterView.frame" context:&kTableFooterViewFrameKey];
        }
    }

#pragma mark -

- (UIBarButtonItem *)addButtonItem
    {
    if (addButtonItem == NULL)
        {
        addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
        }
    return(addButtonItem);
    }

#pragma mark -

- (void)setEditing:(BOOL)inEditing animated:(BOOL)inAnimated
    {
    [super setEditing:inEditing animated:inAnimated];
    //
    [self.tableView setEditing:inEditing animated:inAnimated];

    self.addButtonItem.enabled = !inEditing;
    }

- (void)setTableHeaderView:(UIView *)inTableHeaderView
    {
    if (tableHeaderView != inTableHeaderView)
        {
        tableHeaderView = inTableHeaderView;
        self.tableView.tableHeaderView = inTableHeaderView;
        }
    }

- (void)setTableFooterView:(UIView *)inTableFooterView
    {
    if (tableFooterView != inTableFooterView)
        {
        tableFooterView = inTableFooterView;
        self.tableView.tableFooterView = inTableFooterView;
        }
    }

- (IBAction)add:(id)inSender
    {
    }

#pragma mark -

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
    {
    return(0);
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    return(NULL);
    }
    
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
    {
    if (context == &kTableHeaderViewFrameKey && self.observingTableHeaderFrame == YES)
        {
        CGRect theNewRect = [[change valueForKey:@"new"] CGRectValue];
        CGRect theOldRect = [[change valueForKey:@"old"] CGRectValue];
        
        if(CGRectEqualToRect(theNewRect, theOldRect))
           {
           // LOL it didn't actually change yo
           }
        else
           { // abuse the table
           self.observingTableHeaderFrame = NO;
           self.tableView.tableHeaderView = NULL;
           self.tableView.tableHeaderView = self.tableHeaderView;
           self.observingTableHeaderFrame = YES;
           }

        }
    else if (context == &kTableFooterViewFrameKey && self.observingTableFooterFrame == YES)
        {
        CGRect theNewRect = [[change valueForKey:@"new"] CGRectValue];
        CGRect theOldRect = [[change valueForKey:@"old"] CGRectValue];
        
        if(CGRectEqualToRect(theNewRect, theOldRect))
            {
            // LOL it didn't actually change yo
            }
        else
            { // abuse the table
            self.observingTableFooterFrame = NO;
            self.tableView.tableFooterView = NULL;
            self.tableView.tableFooterView = self.tableFooterView;
            self.observingTableFooterFrame = YES;
            }
        }
    }

@end

