//
//  iCalvingBookCell.h
//  iCalvingBook
//
//  Created by Ed Herring on 6/14/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iCalvingBookCell : UITableViewCell {
    UITextField *editField;
    UIView *separatorLineView;
}

@property (nonatomic, retain) UITextField *editField;
@property (nonatomic, retain) UIView *separatorLineView;

- (void)showEditingField:(BOOL)show;

@end
