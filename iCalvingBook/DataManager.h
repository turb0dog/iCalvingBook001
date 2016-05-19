//
//  DataManager.h
//  iCalvingBook
//
//  Created by Jesse Herring on 10/1/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import "Animal.h"
#import "CalvingSeason.h"

OBJC_EXPORT NSString * const DMAnimalListUpdateNotification;
OBJC_EXPORT NSString * const DMAnimalCalvingSeasonListUpdateNotification;

// inform delegate of data related events
@protocol DataManagerDelegateProtocol <NSObject>

@optional
- (void)dataManagerAnimalListUpdatedEvent;
- (void)dataManagerCalvingSeasonListUpdatedEvent;

@end

/*
 Singletone, handles all data access
 
 */
@interface DataManager : NSObject

+ (DataManager *)sharedInstance;

@property (nonatomic, weak) id<DataManagerDelegateProtocol> delegate;

-(Animal *)createAnimalRecord:(NSString *)calfId;
-(BOOL)deleteAnimalRecord:(Animal *)animal;
-(BOOL)updateAnimalRecord:(Animal *)animal1 newCalfId:(NSString *)newCalfId;

-(CalvingSeason *)createCalvingSeasonRecordAnimal1:(Animal *)animal1 scoreForPlayer1:(NSInteger)score1 player2:(Animal *)player2 scoreForPlayer2:(NSInteger)score2;

//-(Game *)createCalvingSeasonRecordForDate:(NSDate *)date animal1:(Animal *)animal1 scoreForPlayer1:(NSInteger)score1 player2:(Animal *)player2 scoreForPlayer2:(NSInteger)score2;

//-(BOOL)updateGameRecord:(Game *)game date:(NSDate *)date player1:(Animal *)player1 scoreForPlayer1:(NSInteger)score1 player2:(Animal *)player2 scoreForPlayer2:(NSInteger)score2;

@property (nonatomic, readonly) NSArray *ratedAnimals;
@property (nonatomic, readonly) NSArray *calvingSeasonsByDate;

-(Animal *)animalByCalfId:(NSString *)calfId;

@end
