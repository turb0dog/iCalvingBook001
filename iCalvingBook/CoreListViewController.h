//
//  CoreListViewController.h
//  iDo
//
//  Created by Recording on 2/7/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h"
#import "Category.h"
#import "DetailViewController.h"

@protocol CoreListViewControllerDelegate <NSObject>

- (void)selectedObject:(id)object;

@end

@interface CoreListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) id <CoreListViewControllerDelegate>delegate;
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (void)changeSortOrder;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)labelHeightForText:(NSString *)text withFont:(UIFont *)font;
- (void)updateTable;

@end
