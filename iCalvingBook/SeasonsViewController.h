//
//  SeasonsViewController.h
//  iCalvingBook
//
//  Created by Ed Herring on 10/14/13.
//  Copyright (c) 2013 SquirrelScatSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeasonsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *editButton;

@end
