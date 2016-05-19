//
//  Season.h
//  iCalvingBook
//
//  Created by Jesse Herring on 10/25/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Season : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;

@end

@interface Season (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet *)values;
- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItems:(NSSet *)values;
- (void)removeItemsObject:(NSManagedObject *)value;

@end
