//
//  DataGridView.h
//  iCalvingBook
//
//  Created by Jesse Herring on 3/1/15.
//  Copyright (c) 2015 SquirrelScatSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataGridView : UIScrollView <UITableViewDelegate, UITableViewDataSource>
{
    float mColumnWidth;
    int mStartIndex;
    int mEndIndex;
}

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *headerData;

@end
