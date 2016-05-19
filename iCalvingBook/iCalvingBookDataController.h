//
//  iCalvingBookDataController.h
//  iCalvingBook
//
//  Created by Ed Herring on 5/30/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Animal;

@interface iCalvingBookDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterAnimalList;

-(NSUInteger)countOfList;
-(Animal *)objectInListAtIndex:(NSUInteger)theIndex;
-(void)addAnimalWithAnimal:(Animal *)animal;

@end