//
//  iCalvingBookCell.m
//  iCalvingBook
//
//  Created by Ed Herring on 6/14/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import "iCalvingBookCell.h"

static NSString * const kDummyStringForEmptyDetail = @" ";

@implementation iCalvingBookCell

@synthesize editField;
@synthesize separatorLineView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.editField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.editField.clearButtonMode = UITextFieldViewModeWhileEditing;   // has a clear 'x' button to the right
        self.editField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.editField.enabled = NO;
        self.editField.hidden = YES;
        self.editField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        self.editField.font = [UIFont boldSystemFontOfSize:15];
        self.editField.textColor = [UIColor blackColor];
        self.editField.returnKeyType = UIReturnKeyDone;
        self.editField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [self.contentView addSubview:self.editField]; // attention add to content view !
        
        // separator
        self.separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorLineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.separatorLineView]; // attention add to content view !
    }
    return self;
}

- (void)dealloc {
    
}

- (void)layoutSubviews {
    
    const NSUInteger separatorOffset = 3;
    
    // needs some text in detail
    if ([self.detailTextLabel.text length] == 0) {
        self.detailTextLabel.text = kDummyStringForEmptyDetail;
    }
    
    // please postion the original detail for me
    [super layoutSubviews];
    
    // now place th edit field in the same place as the detail, give max width
    editField.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, self.contentView.frame.size.width-self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.size.height);
    separatorLineView.frame = CGRectMake( editField.frame.origin.x-separatorOffset, 0, 1, self.contentView.bounds.size.height);
}

#pragma mark -
- (void)showEditingField:(BOOL)show;
{
    if (show) {
        separatorLineView.hidden = NO;
        self.detailTextLabel.hidden = YES;
        editField.enabled = YES;
        editField.hidden = NO;
        if ([self.detailTextLabel.text isEqualToString:kDummyStringForEmptyDetail] == NO) {
            editField.text = self.detailTextLabel.text;
        }
    }
    else {
        separatorLineView.hidden = YES;
        editField.enabled = NO;
        editField.hidden = YES;
        self.detailTextLabel.hidden = NO;
        self.detailTextLabel.text = editField.text;
    }
    
}

@end