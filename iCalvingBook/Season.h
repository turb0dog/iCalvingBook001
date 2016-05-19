//
//  Season.h
//  iCalvingBook
//
//  Created by Ed Herring on 11/15/13.
//  Copyright (c) 2013 SquirrelScatSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Season : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *heldBy;

@end
