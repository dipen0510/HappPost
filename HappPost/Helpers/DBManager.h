//
//  DBManager.h
//  WaterWayz
//
//  Created by Dipen Sekhsaria on 08/01/15.
//  Copyright (c) 2015 Humbhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "SingleNewsObject.h"
#import "RegisterRequestObject.h"

FOUNDATION_EXPORT NSString* getRiverImagesURL;

@interface DBManager : NSObject

+ (id) sharedManager;

-(NSString *) getDatabasePath;
-(void) setupDatabase;



//UPDATE DATA



//FETCH DATA

-(void) getAllUserDetailsAndStoreInSharedClass;
-(NSMutableDictionary *) getAllSettings;
-(NSMutableArray *) getAllNews;
-(NSMutableArray *) getAllNewsGenreForNewsId:(NSString *)newsId;
-(NSMutableArray *) getAllNewsCommentsForNewsId:(NSString *)newsId;
-(NSMutableArray *) getAllNewsInfographicsForNewsId:(NSString *)newsId;


//INSERT DATA

-(void) insertEntryIntoUserTableWithUserId:(NSString *)userId andOtherUserDetails:(RegisterRequestObject *)userObj;
-(void) insertEntryIntoSettingsTableWithTimeStamp:(NSString *)timeStamp andNotificationSetting:(NSString *)notificationSetting;
-(void) insertEntryIntoNewsTableWithObj:(SingleNewsObject *)newsObj;
-(void) insertEntryIntoNewsGenresTableWithGenreArr:(NSMutableArray *)newsGenresArr andNewsId:(NSString *)newsId;
-(void) insertEntryIntoNewsCommentsTableWithCommentArr:(NSMutableArray *)newsCommentArr andNewsId:(NSString *)newsId;
-(void) insertEntryIntoNewsInfographicsTableWithCommentArr:(NSMutableArray *)newsInfographicsArr andNewsId:(NSString *)newsId;


//DELETE DATA

-(void) deleteAllEntriesFromUserTable;
-(void) deleteAllEntriesFromSettingsTable;
-(void) deleteAllEntriesFromNewsTable;
-(void) deleteAllEntriesFromNewsGenreTable;
-(void) deleteAllEntriesFromNewsCommentTable;
-(void) deleteAllEntriesFromNewsInfographicsTable;

@end