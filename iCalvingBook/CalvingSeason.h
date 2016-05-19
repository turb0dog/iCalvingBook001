//
//  CalvingSeason.h
//  iCalvingBook
//
//  Created by Jesse Herring on 10/1/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CalvingSeason : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;

@end
