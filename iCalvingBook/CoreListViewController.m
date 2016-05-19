//
//  CoreListViewController.m
//  iDo
//
//  Created by Recording on 2/7/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "CoreListViewController.h"

@interface CoreListViewController ()

@end

@implementation CoreListViewController

@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Fetched Results Controller Delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

#pragma mark - IBActions

- (IBAction)detailDoneTapped:(UIStoryboardSegue *)segue
{
    DetailViewController *detailViewController = segue.sourceViewController;
    id selectedObject = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    [selectedObject setValue:detailViewController.titleTextField.text forKey:@"title"];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

#pragma mark - Instance Methods

- (void)changeSortOrder
{
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)labelHeightForText:(NSString *)text withFont:(UIFont *)font
{
    return 0.0f;
}

- (void)updateTable
{
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = appDelegate.managedObjectContext;
    
    return _managedObjectContext;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate saveContext];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIFont *labelFont = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    
    CGFloat heightPadding = 44 - 21;
    CGFloat labelHeight = [self labelHeightForText:[currentObject valueForKey:@"title"] withFont:labelFont];
    
    return labelHeight + heightPadding;
}

#pragma mark - View Lifecycle

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    DetailViewController *detailViewController = (DetailViewController *)fromViewController;
    
    if (detailViewController.alertViewPresented)
    {
        return NO;
    }
    
    if (!detailViewController.titleTextField || detailViewController.titleTextField.text.length == 0)
    {
        detailViewController.alertViewPresented = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"The title can't be blank"
                                                           delegate:detailViewController
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"NavigationBarTintColor"];
    UIColor *tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = tintColor;
    [refreshControl addTarget:self action:@selector(changeSortOrder) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ListBackground"]];
}

@end
