//
//  DataGridView.m
//  iCalvingBook
//
//  Created by Jesse Herring on 3/1/15.
//  Copyright (c) 2015 SquirrelScatSoftware. All rights reserved.
//

#import "DataGridView.h"

@implementation DataGridView


//float MIN_COLUMN_WIDTH = 255;
float MIN_COLUMN_WIDTH = 192;  // Determines the minimum width for each column in the data grid

@synthesize tableView;
@synthesize tableData;
@synthesize headerData;


///////////////////////////////////////////////////////////////////////////////
//Function Name: baseInit
//Description:  Initializes various variables and objects used by the datagrid
///////////////////////////////////////////////////////////////////////////////
-(void) baseInit
{
    tableData = [[NSMutableArray alloc] init];
    mStartIndex = 0;
    mEndIndex = 0;
    mColumnWidth = MIN_COLUMN_WIDTH;
}



///////////////////////////////////////////////////////////////////////////////
//Funtion Name: fillHeader
//Description:  This function creates the column headers of the data grid
///////////////////////////////////////////////////////////////////////////////
-(void) fillHeader
{
    float x = 0;
    float subViewWidth;
    
    int count = mEndIndex - mStartIndex + 1;
    
    mColumnWidth = MIN_COLUMN_WIDTH;
    subViewWidth = MIN_COLUMN_WIDTH * count;
    
    // if the total width is less than the screen width, increase the width of each column
    if(subViewWidth < self.frame.size.width)
    {
        mColumnWidth = self.frame.size.width / count;
        subViewWidth = self.frame.size.width;
    }
    
    CGRect frame = [self frame];
    //mHeaderView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, subViewWidth, 45)];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, 45, subViewWidth, self.frame.size.height - 45) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    [self addSubview: tableView];
    
    UILabel* headerLabel;
    
    //adding columns based on the header data
    for(int i=mStartIndex; i<=mEndIndex; i++)
    {
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, mColumnWidth, 45)];
        x += mColumnWidth;
        headerLabel.text = [headerData objectAtIndex:i];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [headerLabel setBackgroundColor:[UIColor colorWithRed:205.0/255 green:183.0/255 blue:158.0/255 alpha:255.0/255]];
        //[mHeaderView addSubview:headerLabel];
        
        UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(x-1, 0, 1, 45)];
        [bar setBackgroundColor:[UIColor brownColor]];
        //[mHeaderView addSubview:bar];
        bar = nil;
        
        headerLabel = nil;
    }
    
    [self setContentSize:CGSizeMake(subViewWidth, self.frame.size.height)];
    [self setPagingEnabled:TRUE];
    tableView.delegate = self;
    tableView.dataSource = self;
}

#pragma mark UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"DataGridCell";
    UITableViewCell* cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        
        long rowId = indexPath.row;
        NSLog(@" -- DataGridView -- indexPath.row = %ld", (long)indexPath.row);
        NSArray* rowValues;
        
        if(tableData.count >= rowId+1) {
             NSLog(@" -- DataGridView -- mTableData.count = %ld", (unsigned long)tableData.count);
            rowValues = [tableData objectAtIndex:rowId];
        }
        
        
        float x = 0;
        
        //filling in columns
        UILabel* label;
        for(int i=mStartIndex; i<=mEndIndex; i++)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, mColumnWidth, 45)];
            x += mColumnWidth;
            if(rowValues.count>=i+1)
                label.text = [rowValues objectAtIndex:i];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTag:3000+i];
            
            if(rowId%2==1)
                [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:248.0/255 blue:255.0/255 alpha:255.0/255]];
            else
                [label setBackgroundColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:255.0/255]];
            [cell addSubview:label];
            
            //if(i!=mEndIndex)
            {
                UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(x-1, 0, 1, 45)];
                [bar setBackgroundColor:[UIColor brownColor]];
                [cell addSubview:bar];
                bar = nil;
            }
            label = nil;
        }
    }
    else
    {
        long rowId = indexPath.row;
        NSArray* rowValues;
        if(tableData.count >= rowId+1)
            rowValues = [tableData objectAtIndex:rowId];
        
        UILabel* label;
        for(int i=mStartIndex; i<=mEndIndex; i++)
        {
            label = (UILabel*) [cell viewWithTag:3000+i];
            if(rowValues.count>=i+1)
                label.text = [rowValues objectAtIndex:i];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            
            if(rowId%2==1)
                [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:248.0/255 blue:255.0/255 alpha:255.0/255]];
            else
                [label setBackgroundColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:255.0/255]];
            
            label = nil;
        }
    }
    return cell;
}
@end