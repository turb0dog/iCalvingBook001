//
//  AddPlayerViewController.m
//  iCalvingBook
//
//  Created by Jesse Herring on 10/1/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import "AddPlayerViewController.h"

@interface AddPlayerViewController () <UITextFieldDelegate>

@end

@implementation AddPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = _addMode ? @"Add Animal" : @"Edit Animal";
    if (_animal) {
        self.calfIdEditField.text = _animal.calfId;
    }
    self.doneButton.enabled = [self.calfIdEditField.text length] > 0;
}

#pragma mark - UITextFieldDelegate

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.doneButton.enabled = [string length] > 0;
    return YES;
}

- (IBAction)doneAction:(id)sender {
    if (self.doneButton.enabled == NO)
        return;
    if (_addMode) {
        Animal *animal = [[DataManager sharedInstance] createAnimalRecord:self.calfIdEditField.text];
        if (animal == nil) {
            [Utils showSimpleError:@"Animal with the same Calf Id already exists"];
            return;
        }
    }
    else {
        if ([_animal.calfId isEqualToString:self.calfIdEditField.text] == NO) {
            BOOL success = [[DataManager sharedInstance] updateAnimalRecord:_animal newCalfId:self.calfIdEditField.text];
            if (success == NO) {
                [Utils showSimpleError:@"Cannot change the Calf Id"];
                return;
            }
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
