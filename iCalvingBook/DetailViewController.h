//
//  DetailViewController.h
//  iDo
//
//  Created by Recording on 1/4/13.
//  Copyright (c) 2013 Felipe Laso Marsetti. All rights reserved.
//

@interface DetailViewController : UIViewController

@property (assign, nonatomic) BOOL alertViewPresented;
@property (copy, nonatomic) NSString *objectTitle;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end
