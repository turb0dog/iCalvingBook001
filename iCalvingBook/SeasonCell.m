//
//  SeasonCell.m
//  iCalvingBook
//
//  Created by Jesse Herring on 10/25/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import "SeasonCell.h"

@implementation SeasonCell

- (NSString *)accessibilityHint
{
    if (self.editing)
    {
        return @"Edit season year";
    }
    
    return @"View Seasons";
}

- (NSString *)accessibilityValue
{
    return [NSString stringWithFormat:@"%@, %@ animals born this season", self.yearLabel.text, self.animalCountLabel.text];
}

#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (NSLayoutConstraint *cellConstraint in self.constraints)
    {
        [self removeConstraint:cellConstraint];
        
        id firstItem = cellConstraint.firstItem == self ? self.contentView : cellConstraint.firstItem;
        id secondItem = cellConstraint.secondItem == self ? self.contentView : cellConstraint.secondItem;
        
        NSLayoutConstraint *contentViewConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                                 attribute:cellConstraint.firstAttribute
                                                                                 relatedBy:cellConstraint.relation
                                                                                    toItem:secondItem
                                                                                 attribute:cellConstraint.secondAttribute
                                                                                multiplier:cellConstraint.multiplier
                                                                                  constant:cellConstraint.constant];
        [self.contentView addConstraint:contentViewConstraint];
    }
}

@end
