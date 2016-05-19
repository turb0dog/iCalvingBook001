//
//  DataGridRow.m
//

#import "DataGridColumn.h"
#import <QuartzCore/QuartzCore.h>
#import "HeaderView.h"

@implementation DataGridColumn

@synthesize dataGridDelegate = _dataGridDelegate;
@synthesize dataGridColumnDelegate = _dataGridColumnDelegate;

@synthesize columnNumber = _columnNumber;
@synthesize numberOfRows = _numberOfRows;
@synthesize headerViewTextColor = _headerViewTextColor;
@synthesize headerViewBackgroundColor = _headerViewBackgroundColor;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize columnSelected = _columnSelected;
@synthesize baseFrame = _baseFrame;

#pragma mark - initWithFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initColumn]; //init all components of the column
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _dataGridDelegate = nil;
    _dataGridColumnDelegate = nil;
}

#pragma mark - notification
//choose appropriate when notification received
- (void)receiveColumnNotification:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *key = [[userInfo allKeys] lastObject];
    
    if ([key isEqualToString:select]) { //select cell from specific row
        NSNumber *number = [userInfo valueForKey:[[userInfo allKeys] lastObject]];
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else if ([key isEqualToString:deselct]){ //deselect cell from specific row
        NSNumber *number = [userInfo valueForKey:[[userInfo allKeys] lastObject]];
        [self deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0] animated:NO];
    }
}

#pragma mark - properties implementation
- (void)setDataGridDelegate:(id<DataGridDelegate>)dataGridDelegate
{
    _dataGridDelegate = dataGridDelegate;
    [self reloadData];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
}

- (void)setHeaderViewBackgroundColor:(UIColor *)headerViewBackgroundColor
{
    _headerViewBackgroundColor = headerViewBackgroundColor;
}
- (void)setHeaderViewTextColor:(UIColor *)headerViewTextColor
{
    _headerViewTextColor = headerViewTextColor;
}

#pragma mark - Table View Data Source & Delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //obtain cell from view controller
    DataGridCell *cell = [_dataGridDelegate dataGrid:(id)self.superview cellForColumn:_columnNumber row:indexPath.row];
    [cell setFrame:CGRectMake(0, 0, self.frame.size.width, cellHeight)];
    //draw cell outline
    [cell layer].masksToBounds = YES;
    [cell layer].borderWidth = _borderWidth;
    [cell layer].borderColor = [_borderColor CGColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _numberOfRows =  [_dataGridDelegate numberOfRowsInDataGrid:(id)self.superview];
    return  _numberOfRows;
}


//call method of delegate, when user hits on cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_dataGridDelegate respondsToSelector:@selector(dataGrid:didSelectCellAtColumn:row:)]) {
        [_dataGridDelegate dataGrid:(id)self.superview didSelectCellAtColumn:_columnNumber row:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cellHeight = [_dataGridDelegate dataGrid:(id)self.superview heightOfRow:indexPath.row];
    return cellHeight;
}

//If headerViewHeight method not found - return 0;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([_dataGridDelegate respondsToSelector:@selector(headerViewHeight)]) {
        return headerViewHeight = [_dataGridDelegate headerViewHeight];
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //NSLog(@" -----  DataGridColumn(viewForHeaderInSection)");
    UIView *view = nil;
    if([_dataGridDelegate respondsToSelector:@selector(headerViewForColumn:)]) { //if user returns custom header view - use this view.
        view = [_dataGridDelegate headerViewForColumn:_columnNumber];
    }
    if(!view) {
        NSString *title;
        if([_dataGridDelegate respondsToSelector:@selector(titleForColumn:)]) {
            title = [_dataGridDelegate titleForColumn:_columnNumber]; //if user has title for specific header view - use this title
            if(title) {
                HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, headerViewHeight)];
                
                //setup header view outline
                [headerView layer].masksToBounds = YES;
                [headerView layer].borderColor = [_borderColor CGColor];
                [headerView layer].borderWidth = _borderWidth;
                headerView.backgroundColor = _headerViewBackgroundColor;
                
                [headerView setTitleColor:_headerViewTextColor forState:UIControlStateNormal];
                [headerView setTitleColor:_headerViewTextColor forState:UIControlStateHighlighted];
                [headerView setTitle:title forState:UIControlStateNormal];
                [headerView addTarget:self action:@selector(setSelectedFromTouchEvent:) forControlEvents:UIControlEventTouchUpInside]; //add selector. When user clicks on header - select/deselct column.
                [headerView.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [headerView.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
                
                //Add gesture recognizer to header view. Use this gesture recognizer to handle column dragging.
                if(editingEnabled) {
                    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
                    [longPressGestureRecognizer setMinimumPressDuration:0.8];
                    [headerView addGestureRecognizer: longPressGestureRecognizer];
                    //[longPressGestureRecognizer release];
                }
                return headerView;
            }
        }
        return nil;
    }
    //if custom view exists - set applicalable frame to it and add gesture recognizer
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    
    if(editingEnabled) {
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [longPressGestureRecognizer setMinimumPressDuration:0.8];
        [view addGestureRecognizer:longPressGestureRecognizer];
        //[longPressGestureRecognizer release];
    }
    return view;
}

#pragma mark - public methods implementation
- (void)setEditingEnabled:(BOOL)editing
{
    editingEnabled = editing;
    [self reloadData];
}

//if column selected from touch event, selected = YES. If column selected programatically, selected = NO.
- (void)setSelectedFromTouchEvent:(BOOL)selected
{
    //select all rows programatically.
    for(int currentRow = 0; currentRow < self.numberOfRows; currentRow ++) {
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    //if selection was from touch event
    if(selected) {
        if(_columnSelected) { //if column currently selected - deselect column
            for(int currentRow = 0; currentRow < self.numberOfRows; currentRow ++) {
                [self deselectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] animated:NO];
            }
        }
        else {
            //selected column
            for(int currentRow = 0; currentRow < self.numberOfRows; currentRow ++) {
                [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            //notify method of delegate
            if([_dataGridDelegate respondsToSelector:@selector(DataGrid:didSelectColumn:)]) {
                [_dataGridDelegate dataGrid:(id)self.superview didSelectColumn:_columnNumber];
            }
        }
        _columnSelected = !_columnSelected;
    }
}

// deselct all rows in column
- (void)setDeselected
{
    for(int i = 0; i < self.numberOfRows; i ++) {
        [self deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO ];
    }
    _columnSelected = NO;
}

#pragma mark - private methods implementation
//init and customize column
- (void)initColumn
{
    //NSLog(@" -----  DataGridColumn(initColumn)");
    headerViewHeight = 0;
    [self setEditingEnabled:YES];
    //self.headerViewBackgroundColor = [UIColor blueColor];
    //self.headerViewTextColor = [UIColor whiteColor];
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 0.35;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = self;
    self.delegate = self;
    
    _columnSelected = NO;
    
    //add this column as observer to receive notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColumnNotification:) name:columnNotification object:nil];
}

//call this method, to scroll all columns together with this column
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_dataGridColumnDelegate columnDidScroll:self.contentOffset ];
}

#pragma mark - columns movement
//handle column dragging
- (void)longPressGesture:(UILongPressGestureRecognizer*)longPressGesture
{
    //when gesture began - determing location in superview
    if(longPressGesture.state == UIGestureRecognizerStateBegan) {
        
        columnSavedNumber = _columnNumber;
        xCoordInSuperView = [longPressGesture locationInView:self.superview].x;
        
        //add transparency and bring this column to front
        [self.superview bringSubviewToFront:self];
        [self setAlpha:0.8];
        for(UIView *view in self.subviews) {
            if([view isMemberOfClass:[HeaderView class]]) {
                [view setAlpha:0.98];
            }
            [view setAlpha:0.8];
        }
        
        //self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 5.0;
        self.clipsToBounds = NO;
        
        return;
    }
    
    //while dragging current column
    if(longPressGesture.state == UIGestureRecognizerStateChanged)
    {
        //obtain current location of touch in this column and in superview
        float currentXCoordInSuperView = [longPressGesture locationInView:self.superview].x;
        
        //compare start and previous locations of the view
        if (currentXCoordInSuperView > xCoordInSuperView + 1) {
            [_dataGridColumnDelegate columnDidDrag:self direction:DragDirectionRight locationOfTouch:currentXCoordInSuperView];
        }
        else if(currentXCoordInSuperView < xCoordInSuperView - 1) {
            [_dataGridColumnDelegate columnDidDrag:self direction:DragDirectionLeft locationOfTouch:currentXCoordInSuperView];
        }
        
        //set new coord to previous location
        xCoordInSuperView = currentXCoordInSuperView;
        return;
    }
    //if gesture was ended, gesture was failed or cancelled
    if(longPressGesture.state == UIGestureRecognizerStateCancelled || longPressGesture.state == UIGestureRecognizerStateFailed || longPressGesture.state == UIGestureRecognizerStateEnded) {
        
        //remove all transparency
        [self setAlpha:1.0];
        for(UIView *view in self.subviews) {
            [view setAlpha:1.0];
        }
        
        //self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 0;
        self.clipsToBounds = NO;
        
        [_dataGridColumnDelegate columnDraggingEnded:self fromNumber:columnSavedNumber toNumber:_columnNumber ];
    }
}
@end