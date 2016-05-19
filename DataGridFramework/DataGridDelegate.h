//
//  DataGridDelegate.h
//

#import <Foundation/Foundation.h>
#import "DataGrid.h"
#import "DataGridColumn.h"

//DataGrid notification keys
#define columnNotification @"column" //name of the notification
#define select @"select" //Used when user selects row
#define deselct @"deselct" //Used when user deselects row

//Needed to represent direction of dragging
typedef enum {
    DragDirectionLeft = 0,
    DragDirectionRight = 1
} DragDirection;

@class DataGrid;
@class DataGridColumn;
@class DataGridCell;

@protocol DataGridDelegate <NSObject>

@required
- (int)numberOfRowsInDataGrid:(DataGrid*)dataGrid; 
- (int)numberOfColumnsInDataGrid:(DataGrid*)dataGrid;
- (float)dataGrid:(DataGrid*)dataGrid heightOfRow:(int)rowNumber;
- (float)dataGrid:(DataGrid*)dataGrid widthOfColumn:(int)columnNumber;
- (DataGridCell*)dataGrid:(DataGrid*)dataGrid cellForColumn:(int)columnNumber row:(int)rowNumber;

@optional
- (void)dataGrid:(DataGrid*)dataGrid didSelectCellAtColumn:(int)columnNumber row:(int)rowNumber;
- (void)dataGrid:(DataGrid *)dataGrid didSelectColumn:(int)columnNumber;
- (void)dataGrid:(DataGrid*)dataGrid moveColumnFrom:(int)sourceColumnNumber toColumn:(int)destinationColumnNumber;
- (UIView*)headerViewForColumn:(int)columnNumber; //This method must be return custom header view for each column. Use if you not implement - (NSString*)titleForColumn:(int)columnNumber;
- (NSString*)titleForColumn:(int)columnNumber; //returns string title for each default header view. Use if you not implement - (UIView*)headerViewForColumn:(int)columnNumber;
- (float)headerViewHeight; //If you implement this method and this method returns value different from 0, implement 1 of 2 previous methods.
@end


@protocol DataGridColumnDelegate <NSObject>
@required
- (void)columnDidScroll:(CGPoint)contentOffset;
- (void)columnDidDrag:(DataGridColumn*)column direction:(DragDirection)direction locationOfTouch:(float)location;
- (void)columnDraggingEnded:(DataGridColumn*)column fromNumber:(int)fromNumber toNumber:(int)toNumber;

@end

