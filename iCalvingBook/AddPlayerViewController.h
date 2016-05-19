//
//  AddPlayerViewController.h
//  iCalvingBook
//
//  Created by Jesse Herring on 10/1/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animal.h"
#import "Utils.h"
#import "DataManager.h"

/*
 Simple Add New or Edit Player form
 */
@interface AddPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *calfIdEditField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) BOOL addMode;
@property (nonatomic, weak) Animal *animal;

- (IBAction)doneAction:(id)sender;

@end
