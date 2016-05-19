//
//  ItemListViewController.m
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "SeasonListViewController.h"
#import "Item.h"
#import "ItemCell.h"
#import "ItemListViewController.h"

NSString *const itemListSortAscendingKey = @"itemListSortAscending";

@interface ItemListViewController ()

@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@end

@implementation ItemListViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - IBActions

- (IBAction)editTapped:(UIBarButtonItem *)sender
{
    __weak ItemListViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (sender.style == UIBarButtonItemStyleDone)
                         {
                             [sender setTitle:@"Edit"];
                             [sender setStyle:UIBarButtonItemStyleBordered];
                             
                             [weakSelf setNavigationItemButtonsForEditing:YES];
                         }
                         else
                         {
                             [sender setTitle:@"Done"];
                             [sender setStyle:UIBarButtonItemStyleDone];
                             
                             [weakSelf setNavigationItemButtonsForEditing:NO];
                         }
                     }
                     completion:nil];
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - Instance Methods

- (void)changeSortOrder
{
    _fetchedResultsController = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sortAscending = [userDefaults boolForKey:itemListSortAscendingKey];
    
    [userDefaults setBool:!sortAscending forKey:itemListSortAscendingKey];
    [userDefaults synchronize];
    
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1.0];
}

- (void)configureCell:(ItemCell *)itemCell atIndexPath:(NSIndexPath *)indexPath
{
    Category *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    itemCell.nameLabel.text = category.title;
}

- (CGFloat)labelHeightForText:(NSString *)text withFont:(UIFont *)font
{
    CGFloat widthPadding = 40;
    
    CGSize constrainSize = CGSizeMake(self.tableView.frame.size.width - widthPadding, 100);
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:constrainSize];
    
    return labelSize.height;
}

#pragma mark - Private Methods

- (void)addTapped
{
    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    newItem.category = self.category;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

- (void)setNavigationItemButtonsForEditing:(BOOL)editing
{
    if (!editing)
    {
        [self.navigationItem setBackBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItem:self.addButton animated:YES];
    }
    else
    {
        [self.navigationItem setBackBarButtonItem:self.backButton];
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    }
}

#pragma mark - Properties

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sortAscending = [userDefaults boolForKey:itemListSortAscendingKey];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:sortAscending];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", self.category];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    fetchedResultsController.delegate = self;
    _fetchedResultsController = fetchedResultsController;
    
    NSError *error;
    
    if (![self.fetchedResultsController performFetch:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Load Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    return _fetchedResultsController;
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    
    [self configureCell:itemCell atIndexPath:indexPath];
    
    return itemCell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            UINavigationController *navigationController = (UINavigationController *)self.parentViewController;
            SeasonListViewController *categoryListViewController = navigationController.viewControllers[0];
            
            [categoryListViewController.delegate selectedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else
        {
            [self performSegueWithIdentifier:@"ItemDetailSegue" sender:self];
        }
    }
}

#pragma mark - View Lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ItemListViewController *itemListViewController = segue.sourceViewController;
    NSIndexPath *selectedRowIndexPath = [itemListViewController.tableView indexPathForSelectedRow];
    
    ItemCell *itemCell = (ItemCell *)[itemListViewController.tableView cellForRowAtIndexPath:selectedRowIndexPath];
    NSString *categoryName = itemCell.nameLabel.text;
    
    if ([segue.identifier isEqualToString:@"ItemDetailSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailViewController = (DetailViewController *)[navigationController.viewControllers lastObject];
        detailViewController.objectTitle = categoryName;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addTapped)];
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Categories" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = self.backButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.categoryNameString;
}

@end
