//
//  DetailViewController_iPad.m
//  iDo
//
//  Created by Recording on 4/30/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

#import "DetailViewController_iPad.h"

@interface DetailViewController_iPad () <UITextFieldDelegate>

@property (strong, nonatomic) id detailObject;
@property (strong, nonatomic) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation DetailViewController_iPad

#pragma mark - Core List View Controller Delegate

- (void)selectedObject:(id)object
{
    self.detailObject = object;
    
    self.titleTextField.text = [object valueForKey:@"title"];
    
    [self.titleTextField becomeFirstResponder];
    
    if (self.popover)
    {
        [self.popover dismissPopoverAnimated:YES];
    }
}

#pragma mark - Private Methods

- (void)viewTapped
{
    if ([self.titleTextField isFirstResponder])
    {
        [self.titleTextField resignFirstResponder];
    }
}

#pragma mark - Split view Controller Delegate

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    self.popover = pc;
    
    barButtonItem.title = @"List";
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    self.popover = nil;
}

#pragma mark - Text Field Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] == 0 && self.detailObject)
    {
        [textField becomeFirstResponder];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"The title can't be blank"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [self.detailObject setValue:textField.text forKey:@"title"];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate saveContext];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(viewTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DetailBackground"]];
}

@end
