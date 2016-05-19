//
//  Utils.m
//  iCalvingBook
//
//  Created by Jesse Herring on 10/1/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)showSimpleError:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
}

@end
