//
//  iCalvingBookDataController.m
//  iCalvingBook
//
//  Created by Ed Herring on 5/30/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import "iCalvingBookDataController.h"
//#import "Animal.h"


@interface iCalvingBookDataController ()

- (void)initializeDefaultDataList;

@end

@implementation iCalvingBookDataController

-(id)init {
    if (self = [super init]) {
        //[self initializeDefaultDataList];
        return self;
    }
    return nil;
}

-(void)initializeDefaultDataList {
    //NSMutableArray *animalList = [[NSMutableArray alloc] init];
    //self.masterAnimalList = animalList;
    //Animal *animal;
    //NSDate *today = [NSDate date];
    //animal = [[Animal alloc] initWithCalfId:@"1001" birthDate:today birthWeight:@"54"];
    //[self addAnimalWithAnimal:animal];
}

-(void)setMasterAnimalList:(NSMutableArray *)newList {
    if (_masterAnimalList != newList) {
        _masterAnimalList = [newList mutableCopy];
    }
}

-(NSUInteger)countOfList {
    return [self.masterAnimalList count];
}

-(Animal *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterAnimalList objectAtIndex:theIndex];
}

-(void)addAnimalWithAnimal:(Animal *)animal {
    [self.masterAnimalList addObject:animal];
}

@end
