//
//  DataManager.m
//  iCalvingBook
//
//  Created by Jesse Herring on 10/1/14.
//  Copyright (c) 2014 SquirrelScatSoftware. All rights reserved.
//

#import "DataManager.h"
#import "CoreData/CoreData.h"

NSString * const DMAnimalListUpdateNotification = @"DMAnimalListUpdateNotification";
NSString * const DMAnimalGameListUpdateNotification = @"DMAnimalGameListUpdateNotification";

NSString* const AnimalEntity = @"Animal";
NSString* const GameEntity = @"Game";

@interface DataManager() {
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    
    NSArray *_ratedAnimals; // players, sorted by score
    NSArray *_animalsByDate; // animals, sorted by date
    NSMutableDictionary *_animalsByCalfId; // O(1) search for an animal by calfId
}

@end

@implementation DataManager

+ (DataManager *)sharedInstance {
    static DataManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DataManager alloc] init];
    });
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initAllForCoreDataAccess];
    }
    return self;
}

#pragma mark - Core Data

- (void)initAllForCoreDataAccess {
    // 1 - model
    NSURL* modelURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"Model" ofType: @"momd"]];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];
   
    // 2 - store
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"iCalvingBook.sqlite"]];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES};
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSPersistentStore *store = nil;
    store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
    if (!store) {
        NSLog(@"Database error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    // 3 - context
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator: _persistentStoreCoordinator];
    
    [self initWithDemoItemsIfNeeded];
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

-(BOOL)persistCoreDataChanges {
    NSError *anyError;
    if (_managedObjectContext) {
        if ([_managedObjectContext save:&anyError] == YES)
            return YES;
        // error - rollback
        NSLog(@"Persist Error: %@, %@", anyError, [anyError userInfo]);
        [_managedObjectContext rollback];
    }
    return NO;
}

// see if no records - add some default values
- (void)initWithDemoItemsIfNeeded {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:AnimalEntity inManagedObjectContext:_managedObjectContext]];
    NSError *err;
    NSUInteger count = [_managedObjectContext countForFetchRequest:request error:&err];
    if (count > 0)
        return;
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:GameEntity inManagedObjectContext:_managedObjectContext]];
    count = [_managedObjectContext countForFetchRequest:request error:&err];
    if (count > 0)
        return;
    
    // if we don't have any recotds in both DBs, recreate these:
    //Animal *animalA = [self createAnimalRecordInternal:@"Amos"];
    //Animal *animalB = [self createAnimalRecordInternal:@"Diego"];
    //Animal *animalC = [self createAnimalRecordInternal:@"Joel"];
    //Animal *playerTim = [self createPlayerRecordInternal:@"Tim"];
    [self createAnimalRecordInternal:@"1001"]; // no games yet!
    
   // [self createGameRecordPlayer1:playerAmos scoreForPlayer1:4 player2:playerDiego scoreForPlayer2:5];
   // [self createGameRecordPlayer1:playerAmos scoreForPlayer1:1 player2:playerDiego scoreForPlayer2:5];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:2 player2:playerDiego scoreForPlayer2:5];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:0 player2:playerDiego scoreForPlayer2:5];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:6 player2:playerDiego scoreForPlayer2:5];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:5 player2:playerDiego scoreForPlayer2:2];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:4 player2:playerDiego scoreForPlayer2:0];
    //[self createGameRecordPlayer1:playerJoel scoreForPlayer1:4 player2:playerDiego scoreForPlayer2:5];
    //[self createGameRecordPlayer1:playerTim scoreForPlayer1:4 player2:playerAmos scoreForPlayer2:5];
    //[self createGameRecordPlayer1:playerTim scoreForPlayer1:5 player2:playerAmos scoreForPlayer2:2];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:3 player2:playerTim scoreForPlayer2:5];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:5 player2:playerTim scoreForPlayer2:3];
    //[self createGameRecordPlayer1:playerAmos scoreForPlayer1:5 player2:playerJoel scoreForPlayer2:4];
    //[self createGameRecordPlayer1:playerJoel scoreForPlayer1:5 player2:playerTim scoreForPlayer2:2];
}

- (void)clearAllInMemoryAnimalLists {
    _ratedAnimals = nil;
    _animalsByCalfId = nil;
    if ([self.delegate respondsToSelector:@selector(dataManagerAnimalListUpdatedEvent)]) {
        [self.delegate dataManagerAnimalListUpdatedEvent];
    }
    // notify observers that are not active now
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DMAnimalListUpdateNotification object:nil];
    });
}

- (void)clearAllInMemoryCalvingSeasonsLists {
    _calvingSeasonsByDate = nil;
    
    // we need to reload players too
    _ratedAnimals = nil;
    _animalsByCalfId = nil;
    
    if ([self.delegate respondsToSelector:@selector(dataManagerCalvingSeasonListUpdatedEvent)]) {
        [self.delegate dataManagerCalvingSeasonListUpdatedEvent];
    }
    if ([self.delegate respondsToSelector:@selector(dataManagerAnimalListUpdatedEvent)]) {
        [self.delegate dataManagerAnimalListUpdatedEvent];
    }
    // notify observers that are not active now
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DMAnimalCalvingSeasonListUpdateNotification object:nil];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DMAnimalListUpdateNotification object:nil];
    });
}



- (void)buildRatedAnimalsList {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // look for all animals
    [request setEntity:[NSEntityDescription entityForName:AnimalEntity inManagedObjectContext:_managedObjectContext]];
    
    // sort them by calf Id
    //NSSortDescriptor *sortDescScore = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSSortDescriptor *sortDescCalfId = [[NSSortDescriptor alloc] initWithKey:@"calfId" ascending:YES];
    NSArray *sortDescriptors = @[sortDescCalfId];
    [request setSortDescriptors:sortDescriptors];
    NSError* error = nil;
    _ratedAnimals = [_managedObjectContext executeFetchRequest: request error: &error];
    
    // rebuild quick access hashtable
    _animalsByCalfId = [NSMutableDictionary dictionaryWithCapacity:[_ratedAnimals count]];
    for (Animal *animal in _ratedAnimals) {
        [_animalsByCalfId setObject:animal forKey:animal.calfId];
    }
}



/*
- (void)buildGamesByDateList {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // look for all players
    [request setEntity:[NSEntityDescription entityForName:GameEntity inManagedObjectContext:_managedObjectContext]];
    // sort them by score
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDesc];
    [request setSortDescriptors:sortDescriptors];
    NSError* error = nil;
    _gamesByDate = [_managedObjectContext executeFetchRequest: request error: &error];
}
*/
 

#pragma mark - public access
- (Animal *)findTheAnimal:(NSString *)calfId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:AnimalEntity inManagedObjectContext:_managedObjectContext]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(calfId = %@)", calfId];
    [request setPredicate:pred];
    
    NSError* error = nil;
    NSArray* result = [_managedObjectContext executeFetchRequest:request error:&error];
    if (result && [result count] == 1) {
        return (Animal *)[result objectAtIndex:0];
    }
    return nil;
}

- (Animal *)createAnimalRecordInternal:(NSString *)calfId {
    Animal *animal = (Animal *)[NSEntityDescription insertNewObjectForEntityForName:AnimalEntity inManagedObjectContext:_managedObjectContext];
    animal.calfId = calfId;
    //player.playerId =  [[NSUUID UUID] UUIDString];
    if ([self persistCoreDataChanges] == YES) {
        return animal;
    }
    return nil;
}

- (Animal *)createAnimalRecord:(NSString *)calfId {
    
    // check if player exists
    Animal *animal = [self findTheAnimal:calfId];
    
    if (animal)
        return nil;
    animal = [self createAnimalRecordInternal:calfId];
    if (animal) {
        [self clearAllInMemoryAnimalLists];
    }
    return animal;
}


- (BOOL)updateAnimalRecord:(Animal *)animal1 newCalfId:(NSString *)newCalfId {
    Animal *animal = [self findTheAnimal:newCalfId];
    if (animal) {
        return NO; // we already have an animal with new Calf Id
    }
    animal1.calfId = newCalfId;
    if ([self persistCoreDataChanges] == NO) {
        return NO;
    }
    [self clearAllInMemoryAnimalLists];
    return YES;
}


- (BOOL)deleteAnimalRecord:(Animal *)animal {
    
    // first, let's see if we have any games for this player
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:AnimalEntity inManagedObjectContext:_managedObjectContext]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(animal1 calfId = %@)", animal.calfId ];//, player.playerId];
    [request setPredicate:pred];
    
    NSError *err;
    NSUInteger count = [_managedObjectContext countForFetchRequest:request error:&err];
    if (count > 0)
        return NO;
    
    // No games - we're Ok to delete
    [_managedObjectContext deleteObject:animal];
    if ([self persistCoreDataChanges] == NO) {
        return NO;
    }
    [self clearAllInMemoryAnimalLists];
    return YES;
}


/*
- (Game *)createGameRecordPlayer1:(Animal *)player1 scoreForPlayer1:(NSInteger)score1 player2:(Animal *)player2 scoreForPlayer2:(NSInteger)score2
{
    return [self createGameRecordForDateInternal:[NSDate date] player1:player1 scoreForPlayer1:score1 player2:player2 scoreForPlayer2:score2];
}
 */



-(CalvingSeason *)createCalvingSeasonRecordForDateInternal:(NSDate *)startDate animal1:(Animal *)animal1 scoreForPlayer1:(NSInteger)score1 player2:(Animal *)player2 scoreForPlayer2:(NSInteger)score2 {
    
    CalvingSeason *calvingSeason = (CalvingSeason *)[NSEntityDescription insertNewObjectForEntityForName:CalvingSeasonEntity inManagedObjectContext:_managedObjectContext];
    calvingSeason.startDate = startDate;
    game.gameId =  [[NSUUID UUID] UUIDString];
    game.player1Id = player1.playerId;
    game.player1Score = [NSNumber numberWithInteger:score1];
    
    game.player2Id = player2.playerId;
    game.player2Score = [NSNumber numberWithInteger:score2];
    
    // update scores for players
    player1.score = [NSNumber numberWithInteger: [player1.score integerValue] + score1];
    player2.score = [NSNumber numberWithInteger: [player2.score integerValue] + score2];
    
    if ([self persistCoreDataChanges] == YES) {
        return game;
    }
    return nil;
}


/*
- (Game *)createGameRecordForDate:(NSDate *)date player1:(Animal *)player1 scoreForPlayer1:(NSInteger)score1 player2:(Animal *)player2 scoreForPlayer2:(NSInteger)score2 {
    Game *game = [self createGameRecordForDateInternal:date player1:player1 scoreForPlayer1:score1 player2:player2 scoreForPlayer2:score2];
    if (game != nil) {
        [self clearAllInMemoryGamesLists];
    }
    return game;
}
*/

/*
- (BOOL)updateGameRecord:(Game *)game date:(NSDate *)date player1:(Animal *)player1 scoreForPlayer1:(NSInteger)score1 player2:(Animal *)player2 scoreForPlayer2:(NSInteger)score2
{
    if ([game.player1Id isEqualToString:player1.playerId] == NO) {
        // subtract score from tjhe player we had before
        Animal *oldPlayer = [self playerById:game.player1Id];
        oldPlayer.score = [NSNumber numberWithInteger: [oldPlayer.score integerValue] - [game.player1Score integerValue]];
        player1.score = [NSNumber numberWithInteger: [player1.score integerValue] + score1];
    } else {
        player1.score = [NSNumber numberWithInteger: [player1.score integerValue] - [game.player1Score integerValue] + score1];
    }
    if ([game.player2Id isEqualToString:player2.playerId] == NO) {
        // subtract score from tjhe player we had before
        Animal *oldPlayer = [self playerById:game.player2Id];
        oldPlayer.score = [NSNumber numberWithInteger: [oldPlayer.score integerValue] - [game.player2Score integerValue]];
    } else {
        player2.score = [NSNumber numberWithInteger: [player2.score integerValue] - [game.player2Score integerValue] + score2];
    }
    game.date = date;
    
    game.player1Id = player1.playerId;
    game.player1Score = [NSNumber numberWithInteger:score1];
    
    game.player2Id = player2.playerId;
    game.player2Score = [NSNumber numberWithInteger:score2];
    
    if ([self persistCoreDataChanges] == NO) {
        return NO;
    }
    [self clearAllInMemoryGamesLists];
    return YES;
}
*/
 
 
#pragma mark - data access wrappers
- (NSArray *)ratedAnimals {
    if (_ratedAnimals == nil) {
        [self buildRatedAnimalsList];
    }
    return _ratedAnimals;
}

- (NSArray *)calvingSeasonByDate {
    if (_calvingSeasonsByDate == nil) {
        //[self buildCalvingSeasonsByDateList];
    }
    return _calvingSeasonsByDate;
}

- (Animal *)animalByCalfId:(NSString *)calfId {
    if (_animalsByCalfId == nil) {
        //[self buildRatedPlayersList];
    }
    return [_animalsByCalfId objectForKey:calfId];
}


#pragma mark - potential network code

/*
 
 // getting data from network
 
 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 NSURL *url = [NSURL URLWithString:dataURL];
 NSURLSession *urlSession = [NSURLSession sharedSession];
 [[urlSession dataTaskWithURL:url
 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 dispatch_async(dispatch_get_main_queue(), ^{
 // update on Main
 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 });
 if (!error) {
 [self handleDataReceived:data response:response];
 } else {
 [self notifyOnError:error];
 }
 }] resume];
 }
 
 // process data:
 
 - (void)handleDataReceived:(NSData *)data response:(NSURLResponse *)response {
 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
 if (httpResponse.statusCode != 200) {
 NSError *error = [NSError errorWithDomain:@"NETWORK" code:httpResponse.statusCode userInfo:nil];
 [self notifyOnError:error];
 return;
 }
 
 // convert JSON response to dictionary or array
 NSError *jsonError;
 id dataJSON = [NSJSONSerialization JSONObjectWithData:data
 options:NSJSONReadingAllowFragments
 error:&jsonError];
 if (jsonError) {
 [self notifyOnError:jsonError];
 return;
 }
 // parse Array or Dictionary
 }
 
 */

@end
