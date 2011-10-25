//
//  CTableViewController.h
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

#import <UIKit/UIKit.h>

@interface CTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> 

@property (readwrite, nonatomic, strong) IBOutlet UITableView *tableView;
@property (readwrite, nonatomic, assign) UITableViewStyle initialStyle;
@property (readwrite, nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;
@property (readonly, nonatomic, strong) UIBarButtonItem *addButtonItem;

@property (readwrite, nonatomic, strong) IBOutlet UIView *tableBackgroundView;
@property (readwrite, nonatomic, strong) IBOutlet UIView *tableHeaderView;
@property (readwrite, nonatomic, strong) IBOutlet UIView *tableFooterView;

- (IBAction)add:(id)inSender;

@end
