//
//  iCalvingBookViewController.h
//  iCalvingBook
//
//  Created by Ed Herring on 10/9/13.
//  Copyright (c) 2013 SquirrelScatSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMTableView.h"
#import "DataGridView.h"
#import "DataGrid.h"
#import "iCalvingBookDataController.h"

@interface iCalvingBookViewController : UIViewController <DataGridDelegate> {
    
    UMTableView *dataGridView;
    DataGrid *grid;
    NSMutableArray *dataSource;
    NSMutableArray *headers;
    
    int numRows;
    int numCols;
    NSMutableArray *rowLabels;
    NSMutableArray *colLabels;
    NSMutableDictionary *entries;

    
    NSMutableArray *calfIdsArray;
    NSMutableArray *cowIdsArray;
    NSMutableArray *sireIdsArray;
    NSMutableArray *birthDatesArray;
    NSMutableArray *birthWeightsArray;
    NSMutableArray *sexesArray;
    NSMutableArray *weenDatesArray;
    NSMutableArray *weenWeightsArray;
    NSMutableArray *notesArray;
    
    iCalvingBookDataController *dataController;
    
    NSArray *columnData;
}

@end
