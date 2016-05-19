//
//  DataGrid.h
//

#import <UIKit/UIKit.h>
#import "DataGridColumn.h"
#import "DataGridDelegate.h"
#import "DataGridCell.h"

@class DataGridColumn;

/*
 
 Steps for use:
 
 
 1. In project tree right-click at your project root. Choose Add Files to your project.
 Select DataGridFramework folder. Select "Copy items into destination group folders" and choose "Create group for any added folders".
 
 2. If you use ARC, go to Build Phases -> Compiled sources. Add -fno-objc-arc to each .m file of DataGrid.
 
 3. Import "DataGrid.h" to your view controller.
 Add EXDataGridDelegate to protocols, which your view controller conformsю
 
 4. Create new DataGrid view instance in viewDidLoad. Set delegate to self.
 Customize data grid if you need it and add as subview to your view controller.
 
 5. Implement at least, all required the methods of the protocol
 
 Other recommendations:
 
 Keep the column headers in an array / dictionary / etc, in order to avoid incorrect column heading after the column was moved.
 For the reference - see sample project.
 
 DataGrid is a UIScrollView subclass that incorporates a vertical and horizontal scrolling, reordering of rows and columns.
 You can add DataGrid as subview to your ViewController's view.
 
 Column Dragging:
 Set property editingEnabled to YES.
 Hold your finger on a header of column.
 After short time column will gave more transparent and you can move it to another row.
 To column row - press header that contains needed row number.
 
 */


@interface DataGrid : UIScrollView < UIScrollViewDelegate, DataGridColumnDelegate>
{
    UIColor *myColor;
    NSMutableArray *columns; //contains all columns
    
    float columnsWidth; //width of all coulumns
    
    int numberOfColumns; //total number of columns
    int numberOfRows; //number of rows in each column
    
    NSTimer *timer; //timer for columns autoscrolling
    DataGridColumn *draggableColumn; //column, which was dragged
    DragDirection dragDirection; //direction of draggin. See DataGridDelegate.h
    float locationOfTouch; //location of touch in datagrid. Needed to set frame to draggable column
    
}

@property (nonatomic, assign) id<DataGridDelegate> dataGridDelegate; //data grid delegate
@property (nonatomic, retain) UIColor *bordersColor; //color of cell borders and of header view borders
@property (nonatomic, retain) UIColor *headerViewBackgroundColor; //background color for header view for each column.
//set it, if you use standart headerView
@property (nonatomic, retain) UIColor *headerViewTextColor; //text color for header view for each column.
//set it, if you use standart headerView
@property (nonatomic) float bordersWidth; //width of the cell borders
@property (nonatomic,getter =  isEditingEnabled) BOOL editingEnabled; //set YES to enable row reordering.
@property (nonatomic) float timerInterval; //interval of time, which used for autoscrolling
@property (nonatomic) float animationDuration; //duration of  exchange frames of columns
@property (nonatomic) float autoscrollAreaWidth; //width of area from left and right borders of the datagrid, in which autoscrolling enabled

-(DataGridCell*)cellDequeueReusableIdentifier:(NSString*)identifier forColumn:(int)column; //get used cell from cell queue in DataGrid

-(void)reloadData; //reload add data in DataGrid
-(void)reloadColumn:(int)columnNumber; //reload spicific column
-(void)reloadRow:(int)rowNumber; //reload specific row

-(void)navigateToFirstRowAnimated:(BOOL)animated; //scrolls to first row of data grid
-(void)navigateToColumn:(int)columnNumber animated:(BOOL)animated; //scrolls to specific column
-(void)navigateToRow:(int)rowNumber animated:(BOOL)animated; //scrolls to specific row


//Select/Deselct/Move programatically. Methods EXDataGrid delegate will not be called.
-(void)selectColumn:(int)columnNumber; //select column programatically.
-(void)deselectColumn:(int)columnNumber; //deselect column programatically
-(void)selectRow:(int)rowNumber; //select row programatically
-(void)deselectRow:(int)rowNumber; //deselect row programatically
-(void)moveRowFrom:(int)sourceRowNumber toRow:(int)destinationColumnNumber; //move row to another position
-(void)moveColumnFrom:(int)sourceColumnNumber toColumn:(int)destinationColumnNumber; //move column to another position

@end