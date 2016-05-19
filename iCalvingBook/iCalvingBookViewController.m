//
//  iCalvingBookViewController.m
//  iCalvingBook
//
//  Created by Ed Herring on 10/9/13.
//  Copyright (c) 2013 SquirrelScatSoftware. All rights reserved.
//

#import "iCalvingBookViewController.h"
#import "AddAnimalViewController.h"
#import "iCalvingBookCell.h"
#import "DataGridCell.h"
#import "UMTableView.h"

@interface iCalvingBookViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation iCalvingBookViewController {
    //NSMutableArray *calfIds;
    //NSArray *cowIds;

    
}

static NSString *identifier = @"DataGridcell";

/*
 - (void)initializeDefaultDataList {
    NSMutableArray *sightingList = [[NSMutableArray alloc] init];
    self.masterAnimalList = sightingList;
    [self addAnimalWithCalfId:@"0001" sex:@"Male"];
}
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog( @"calling: %@", nibBundleOrNil );
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    //[super loadView];
    //CGRect frm = CGRectMake(0, 0, 600, 400);
    //UMTableView* tableView = [[UMTableView alloc] initWithFrame: frm];
    //tableView.tableViewDelegate = self;
    //[self.view addSubview:tableView];
    
    [super loadView];
    //CGRect frm = CGRectMake(0, 0, 600, 400);
    DataGridView* dataGridView = [DataGridView alloc];
    //tableView.dataGridDelegate = self;
    //[self.view addSubview:tableView];
    
    //define datasource
    //---------------------------------
    NSString *path = [[NSBundle mainBundle]pathForResource:@"iCalvingBook" ofType:@"plist"];
    dataSource = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSLog(@"Loaded dataSource -  = %@", dataSource);
    
    //NSString *path = [[NSBundle mainBundle]pathForResource:@"iCalvingBook" ofType:@"plist"];
    //dataSource = dataGridView.mTableData;
    //NSLog(@"Loaded dataSource -  = %@", dataGridView.mTableData);

    
    //NSString *key = @"calfId";
    //NSLog(@"tableData count: (unsigned long) %lui", (unsigned long)[dataSource count]);
    
    //
    // _func_                %s        current function signature
    // _LINE_                %d        current line number in the source code file
    // _FILE_                %s        Full path to the source code file
    // _PRETTY_FUNCTION_     %s       like _func_, but includes verbose type info in C++ code
    //NSMutableArray *someObject = [NSMutableArray array];
    //NSLog(@"%s:%d someObject=%@", __func__, __LINE__, someObject);
    //[someObject addObject:@"foo"];
    //NSLog(@"%s:%d someObject=%@", __func__, __LINE__, someObject);
    
    
    //double myNumber = 7.7;
    //NSLog(@"number: %@", @(myNumber));
    
    // STACK TRACE CODE
    //NSLog(@"%@", [NSThread callStackSymbols]);
    
    // 1) Get the latest animal
    //------------------------------------
    //NSArray* latestAnimal = dataSource;
    //NSLog(@"animals: %@", latestAnimal);
   // NSDictionary* animal = [latestAnimal objectAtIndex:0];
    //-------------------------------
    
    // 2) Get the calf id, cow id, sire id, ...
    //NSString* calfIdString = [animal objectForKey:@"calfId"];
    //NSString* cowIdString = [animal objectForKey:@"cowId"];
    //NSLog(@" >>>>>>> %@ <<<<<<<<<" , calfIdString);
    //NSLog(@" >>>>>>> %@ <<<<<<<<<" , cowIdString);
    //float outstandingAmount = [loanAmount floatValue] - [fundedAmount floatValue];
    
    /*
    calfIdsArray = [dataSource valueForKey:@"calfId"];
    cowIdsArray = [dataSource valueForKey:@"cowId"];
    sireIdsArray = [dataSource valueForKey:@"sireId"];
    birthDatesArray = [dataSource valueForKey:@"birthDate"];
    birthWeightsArray = [dataSource valueForKey:@"birthWeight"];
    sexesArray = [dataSource valueForKey:@"sex"];
    weenDatesArray = [dataSource valueForKey:@"weenDate"];
    weenWeightsArray = [dataSource valueForKey:@"weenWeight"];
    notesArray = [dataSource valueForKey:@"notes"];
    
    NSArray *array = [tableData valueForKey:@"calfId"];
    
    NSLog(@"calfIds > %@", calfIdsArray);
    NSLog(@"cowIds > %@", cowIdsArray);
    NSLog(@"sireIds > %@", sireIdsArray);
    NSLog(@"birthDates > %@", birthDatesArray);
    NSLog(@"birth weights > %@", birthWeightsArray);
    NSLog(@"sexes > %@", sexesArray);
    NSLog(@"ween dates > %@", weenDatesArray);
    NSLog(@"ween weights > %@", weenWeightsArray);
    NSLog(@"notes > %@", notesArray);
    */
    //dataController.masterAnimalList = dataSource;
    
    //----------------------------------------------------------------------------------------
    //headers = [NSMutableArray arrayWithObjects:@"Calf Id", @"Cow Id", @"Sire Id", @"Birthdate", @"Birth Weight", @"Sex", @"Ween Date", @"Ween Weight", @"Notes", nil];
    //NSLog(@"headers > %@", headers);
    
    
    //dataGridView.mHeaderData = [NSMutableArray arrayWithObjects:@"Calf Id", @"Cow Id", @"Sire Id", @"Birthdate", @"Birth Weight", @"Sex", @"Ween Date", @"Ween Weight", @"Notes", nil];
    
    //create DataGrid
    //-----------------------------
    /*
    grid = [[DataGrid alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [grid setFrame:CGRectMake(0, 63, 330, 456)];
    }
    else {
        [grid setFrame:CGRectMake(74, 50, 620, 540)];
    }
     */
    //-----------------------------------
    //grid.dataGridDelegate = self;
    //grid.bordersWidth = 0.5;
    //[grid setBackgroundColor:[[UIColor alloc] initWithRed:0.01 / 255 green:0.18 / 255 blue:0.61 / 255 alpha:1.0]];
    //-------------------------------
    
    //grid.bordersColor = [UIColor darkGrayColor];
    //grid.headerViewBackgroundColor = [[UIColor alloc] initWithRed:0.01 / 255 green:0.18 / 255 blue:0.61 / 255 alpha:1.0];
    
    //--------------------------------------------
    //[self.view addSubview:grid];
    //------------------------------------------
    
    [self.view addSubview:dataGridView];
}


- (void)viewDidUnload
{
    [grid removeFromSuperview];
    [headers removeAllObjects];
    [dataSource removeAllObjects];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
- (void)dealloc
{
    [super dealloc];
    
}
 */

#pragma mark - DataGridMethods
- (int)numberOfRowsInDataGrid:(DataGrid *)dataGrid
{
    // return (int)self.nRows;
    //NSLog(@" >>num of rows>> %d", [dataSource count]);
    numRows = [dataSource count];
    return numRows;
}

- (int)numberOfColumnsInDataGrid:(DataGrid*)dataGrid;
{
    //return (int)[self.multiDimBarcodes count];
    //NSLog(@" >>num of cols>> %d", [headers count]);
    numCols = [headers count];//[dataSource count];
    return numCols;
}

- (float)dataGrid:(DataGrid *)dataGrid heightOfRow:(int)rowNumber
{
    if(rowNumber == 0) {
        return 40;
    }// else if (rowNumber == 1) {
       // return 120;
    //}
    else {
        return 30;
    }
    
}

- (float)dataGrid:(DataGrid *)dataGrid widthOfColumn:(int)columnNumber
{
    //return different width for different columns
    if (columnNumber == 0 || columnNumber == 1 || columnNumber == 2) {
        return 100;
    }
    else if(columnNumber == 3 || columnNumber == 6 || columnNumber == 4 || columnNumber == 7) {
        return 150;
    }
    else if(columnNumber == 5) {
        return 100;
    }
    else  {
        return 300;
    }
}

- (DataGridCell*)dataGrid:(DataGrid *)dataGrid cellForColumn:(int)columnNumber row:(int)rowNumber
{
    
    //NSLog(@" row-> %d", rowNumber);
    //NSLog(@" column-> %d", columnNumber);
    
    calfIdsArray = [dataSource valueForKey:@"calfId"];
    
    DataGridCell *cell = (DataGridCell*)[dataGrid cellDequeueReusableIdentifier:identifier forColumn:columnNumber];
    //NSLog(@"*******  cell > %@", cell);
    
    if(!cell) {
        cell = [[DataGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // set data to the each cell
    //NSArray *columnData = [dataSource lastObject];
    //[cell.textLabel setText:[columnData objectAtIndex:rowNumber]];
    
    //NSArray *columnData = [dataSource objectAtIndex:columnNumber];
    //NSLog(@"*******  columnData > %@", columnData);
    
    
    //if ([[dataSource lastObject] isEqualToNumber:@"1"]) {
      //  NSLog(@"AAAAAAAAAAAAAA");
        //[cell setOn:[[columnData objectAtIndex:rowNumber] boolValue]];
    //}
    /*
    else if([[dataSource lastObject] rangeOfString:@"AAAAAA"].location!=NSNotFound) {
        NSLog(@"BBBBBBBBBBBBBBBB");
        //UIImage *image = [UIImage imageNamed:[columnData objectAtIndex:rowNumber]];
        //[cell setCityImage:image];
        //[cell.cityImageView setContentMode:UIViewContentModeTopLeft];
    }
     
    else  {
     
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.textLabel setText:[dataSource objectAtIndex:rowNumber]];
    }
     */
    if([columnData count] > rowNumber) {
        //ICBarCode *icBarCode = (ICBarCode*)[columnData objectAtIndex:rowNumber];
        //cell.barcodeLabel.text = icBarCode.barCode;
        //cell.barcodeImageView.image = [UIImage imageNamed:@"Barcode.png"];
    }
    else {
        //cell.barcodeLabel.text =  @"";
        //cell.barcodeImageView.image = nil;
    }
    //set data to the each cell
    columnData = [dataSource objectAtIndex:columnNumber];
    
    
    if (columnNumber == 0) {
        //NSLog(@"*******  cell > %@", cell);
        [cell.textLabel setText:[calfIdsArray objectAtIndex:rowNumber]];
    }
    else if (columnNumber == 1)
        [cell.textLabel setText:[cowIdsArray objectAtIndex:rowNumber]];
    else if (columnNumber == 2)
        [cell.textLabel setText:[sireIdsArray objectAtIndex:rowNumber]];
    //else if (columnNumber == 3)
      //  [cell.textLabel setText:[birthDatesArray objectAtIndex:rowNumber]];
    else if (columnNumber == 4)
        [cell.textLabel setText:[birthWeightsArray objectAtIndex:rowNumber]];
    else if (columnNumber == 5)
        [cell.textLabel setText:[sexesArray objectAtIndex:rowNumber]];
    //else if (columnNumber == 6)
      //  [cell.textLabel setText:[weenDatesArray objectAtIndex:rowNumber]];
    else if (columnNumber == 7)
        [cell.textLabel setText:[weenWeightsArray objectAtIndex:rowNumber]];
    else if (columnNumber == 8)
        [cell.textLabel setText:[notesArray objectAtIndex:rowNumber]];
    
    return cell;
}

- (void)dataGrid:(DataGrid *)dataGrid didSelectColumn:(int)columnNumber
{
    NSLog(@"Selected column %d",columnNumber);
}

- (void)dataGrid:(DataGrid *)dataGrid didSelectCellAtColumn:(int)columnNumber row:(int)rowNumber
{
    NSLog(@"Selected cell at column %d and row %d",columnNumber, rowNumber);
}

- (void)dataGrid:(DataGrid *)dataGrid moveColumnFrom:(int)sourceColumnNumber toColumn:(int)destinationColumnNumber
{
    NSMutableArray *column = [dataSource objectAtIndex:sourceColumnNumber];
    [dataSource removeObjectAtIndex:sourceColumnNumber];
    [dataSource insertObject:column atIndex:destinationColumnNumber];
    
    NSString *header = [headers objectAtIndex:sourceColumnNumber];
    [headers removeObjectAtIndex:sourceColumnNumber];
    [headers insertObject:header atIndex:destinationColumnNumber];
    
    NSLog(@"Move column %d to %d",sourceColumnNumber, destinationColumnNumber);
}

- (float)headerViewHeight
{
    return 40;
}

- (NSString*)titleForColumn:(int)columnNumber
{
    //return [@(columnNumber +1) stringValue];
    return [headers objectAtIndex:columnNumber];
}

- (int) rowHeight {
    return 40;
}

- (int) numColumns {
    return 11;
}

- (int) numRows {
    return 20;
}

// Only 3rd column has a fixed size, the other columns share the remainder
- (int) fixedWidthForColumn: (int) columnIndex {
    if (columnIndex == 2) {
        return 62;
    }
    else {
        return 0;
    }
}

// Only 3rd column has a fixed size
- (Boolean) hasColumnFixedWidth: (int) columnIndex {
    return columnIndex == 2;
}

- (UIColor*) borderColor {
    return [UIColor blackColor];
}

/*
//toggle editing mode
- (IBAction)enableEditing:(id)sender
{
    [grid setEditingEnabled:![grid isEditingEnabled]];
}


//toggle rows selection
- (IBAction)selectRow:(id)sender
{
    UISwitch *sw = (id)sender;
    if(sw.on) {
        [grid selectRow:3];
    } else {
        [grid deselectRow:3];
    }
}
 */

@end
