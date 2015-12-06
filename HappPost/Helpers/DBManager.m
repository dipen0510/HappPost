//
//  DBManager.m
//  WaterWayz
//
//  Created by Dipen Sekhsaria on 08/01/15.
//  Copyright (c) 2015 Humbhi. All rights reserved.
//

#import "DBManager.h"
#import "RegisterRequestObject.h"
#import "SingleNewsObject.h"


NSString* create_TblUser_table = @"CREATE TABLE IF NOT EXISTS USER (userId TEXT PRIMARY KEY, email TEXT, name TEXT, deviceId TEXT, gcmId TEXT, version TEXT)";

NSString* create_TblNews_table = @"CREATE TABLE IF NOT EXISTS NEWS (newsId TEXT PRIMARY KEY, activeFrom TEXT, activeTill TEXT, authorId TEXT, authorName TEXT, dateCreated TEXT, dateModified TEXT, detailedStory TEXT, heading TEXT, impactSore TEXT, latLng TEXT , loc TEXT, name TEXT, newsImage TEXT, newsTimeStamp TEXT, subHeading TEXT, summary TEXT, tags TEXT, isLeadStory TEXT, isTrending TEXT )";

NSString* create_TblNewsComments_table = @"CREATE TABLE IF NOT EXISTS NEWSCOMMENTS (newsCommentsId TEXT PRIMARY KEY, comments TEXT, dateCreated TEXT, user TEXT, newsId TEXT)";

NSString* create_TblNewsGenres_table = @"CREATE TABLE IF NOT EXISTS NEWSGENRES (newsGenreId TEXT PRIMARY KEY, genre TEXT, genreId TEXT, newsId TEXT)";

NSString* create_TblNewsInfographics_table = @"CREATE TABLE IF NOT EXISTS NEWSINFOGRAPHICS (newsInfographicId TEXT PRIMARY KEY, newsImage TEXT, newsId TEXT)";

NSString* create_TblSettings_table = @"CREATE TABLE IF NOT EXISTS SETTINGS (timestamp TEXT, notificationSetting TEXT)";

@implementation DBManager


static DBManager *sharedObject = nil;

+ (id) sharedManager
{
    if (! sharedObject) {
        
        sharedObject = [[DBManager alloc] init];
    }
    return sharedObject;
}

#pragma mark - Database Setup

-(NSString *) getDatabasePath{
    
    NSString* docsDir;
    NSArray* dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    docsDir = dirPaths[0];
    return [docsDir stringByAppendingPathComponent:@"HappPost.db"];
    
}

-(void) setupDatabase{
    
    // Build the path to the database file
    NSString* databasePath  = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    
    NSFileManager* filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        
        if ([objectDB open])
        {
            if([objectDB executeUpdate:create_TblUser_table withArgumentsInArray:nil])
            {
                NSLog(@"USER table created");
            }
            else
            {
                NSLog(@"Failed to create USER table: %@)",[objectDB lastErrorMessage]);
            }
            
            if([objectDB executeUpdate:create_TblNews_table withArgumentsInArray:nil])
            {
                NSLog(@"NEWS table created");
            }
            else
            {
                NSLog(@"Failed to create NEWS table: %@)",[objectDB lastErrorMessage]);
            }
            
            if([objectDB executeUpdate:create_TblNewsComments_table withArgumentsInArray:nil])
            {
                NSLog(@"NEWSCOMMENTS table created");
            }
            else
            {
                NSLog(@"Failed to create NEWSCOMMENTS table: %@)",[objectDB lastErrorMessage]);
            }
            
            if([objectDB executeUpdate:create_TblNewsGenres_table withArgumentsInArray:nil])
            {
                NSLog(@"NEWSGENRES table created");
            }
            else
            {
                NSLog(@"Failed to create NEWSGENRES table: %@)",[objectDB lastErrorMessage]);
            }
            
            if([objectDB executeUpdate:create_TblNewsInfographics_table withArgumentsInArray:nil])
            {
                NSLog(@"NEWSINFOGRAPHICS table created");
            }
            else
            {
                NSLog(@"Failed to create NEWSINFOGRAPHICS table: %@)",[objectDB lastErrorMessage]);
            }
            
            if([objectDB executeUpdate:create_TblSettings_table withArgumentsInArray:nil])
            {
                NSLog(@"SETTINGS table created");
            }
            else
            {
                NSLog(@"Failed to create SETTINGS table: %@)",[objectDB lastErrorMessage]);
            }
            
            [objectDB close];
            
            
        } else {
            NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
        }
    }
    
}


#pragma mark - USER TABLE

-(void) insertEntryIntoUserTableWithUserId:(NSString *)userId andOtherUserDetails:(RegisterRequestObject *)userObj {
    
    [self deleteAllEntriesFromUserTable];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    
    NSArray* arr = [NSArray arrayWithObjects:userId, userObj.email, userObj.name, userObj.deviceId, userObj.gcmId, userObj.ver, nil];
    
    if ([objectDB open]) {
        NSString* query = @"INSERT INTO USER (userId, email, name, deviceId, gcmId, version) VALUES (?, ?, ?, ?, ?, ?)";
        if (![objectDB executeUpdate:query withArgumentsInArray:arr]) {
            
            NSLog(@"insert into USER table failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"User Data inserted Successfully");
        }
        
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}


-(void) getAllUserDetailsAndStoreInSharedClass {
    
    NSString* userId;
    RegisterRequestObject* userObj = [[RegisterRequestObject alloc] init];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"SELECT * from USER";
        FMResultSet* resultSet = [objectDB executeQuery:query withArgumentsInArray:nil];
        if ([resultSet next]) {
            
            userId = [resultSet stringForColumnIndex:0];
            
            userObj.email = [resultSet stringForColumnIndex:1];
            userObj.name = [resultSet stringForColumnIndex:2];
            userObj.deviceId = [resultSet stringForColumnIndex:3];
            userObj.gcmId = [resultSet stringForColumnIndex:4];
            userObj.ver = [resultSet stringForColumnIndex:5];
            userObj.deviceTypeId = iOSDeviceType;
            
            
            
        }
        [objectDB close];
        
        NSLog(@"User Data fetched Successfully");
        
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
    
    [[SharedClass sharedInstance] setUserId:userId];
    [[SharedClass sharedInstance] setUserRegisterDetails:userObj];
    
}


-(void) deleteAllEntriesFromUserTable {
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"DELETE FROM USER";
        if (![objectDB executeUpdate:query withArgumentsInArray:nil]) {
            
            NSLog(@"delete from USER failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"User Data deleted Successfully");
        }
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}







#pragma mark - SETTINGS TABLE

-(void) insertEntryIntoSettingsTableWithTimeStamp:(NSString *)timeStamp andNotificationSetting:(NSString *)notificationSetting {
    
    [self deleteAllEntriesFromSettingsTable];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    
    NSArray* arr = [NSArray arrayWithObjects:timeStamp, notificationSetting, nil];
    
    if ([objectDB open]) {
        NSString* query = @"INSERT INTO SETTINGS (timestamp, notificationSetting) VALUES (?, ?)";
        if (![objectDB executeUpdate:query withArgumentsInArray:arr]) {
            
            NSLog(@"insert into SETTINGS table failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"SETTINGS Data inserted Successfully");
        }
        
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}


-(NSMutableDictionary *) getAllSettings {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"SELECT * from SETTINGS";
        FMResultSet* resultSet = [objectDB executeQuery:query withArgumentsInArray:nil];
        if ([resultSet next]) {
            
            [dict setObject:[resultSet stringForColumnIndex:0] forKey:timestampKey] ;
            [dict setObject:[resultSet stringForColumnIndex:1] forKey:notificationSettingKey] ;
            
            
            
        }
        [objectDB close];
        
        NSLog(@"SETTINGS Data fetched Successfully");
        
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
    
    return dict;
    
}


-(void) deleteAllEntriesFromSettingsTable {
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"DELETE FROM SETTINGS";
        if (![objectDB executeUpdate:query withArgumentsInArray:nil]) {
            
            NSLog(@"delete from SETTINGS failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"SETTINGS Data deleted Successfully");
        }
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}



#pragma mark - NEWS TABLE

-(void) insertEntryIntoNewsTableWithObj:(SingleNewsObject *)newsObj {

    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    
    NSArray* arr = [NSArray arrayWithObjects:newsObj.newsId, newsObj.activeFrom, newsObj.activeTill, newsObj.authorId, newsObj.authorName, newsObj.dateCreated, newsObj.dateModified, newsObj.detailedStory, newsObj.heading, newsObj.impactSore, newsObj.latLng, newsObj.loc, newsObj.name, newsObj.newsImage, newsObj.newsTimeStamp, newsObj.subHeading, newsObj.summary, newsObj.tags, newsObj.isLeadStory, newsObj.isTrending, nil];
    
    if ([objectDB open]) {
        NSString* query = @"INSERT INTO NEWS (newsId, activeFrom, activeTill, authorId, authorName, dateCreated, dateModified, detailedStory, heading, impactSore, latLng , loc, name, newsImage, newsTimeStamp, subHeading, summary, tags, isLeadStory, isTrending ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        if (![objectDB executeUpdate:query withArgumentsInArray:arr]) {
            
            NSLog(@"insert into NEWS table failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"NEWS Data inserted Successfully");
        }
        
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}


- (NSMutableArray *) checkAndFetchNews {
    
    NSString* str = @"(";
    
    if ([[[SharedClass sharedInstance] selectedMyNewsArr] count] > 0) {
        
        for (int i = 0; i<[[[SharedClass sharedInstance] selectedMyNewsArr] count]; i++) {
            
            NSIndexPath* indexpath = (NSIndexPath *)[[[SharedClass sharedInstance] selectedMyNewsArr] objectAtIndex:i];
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld.0",(indexpath.row+1)]];
            if (i < ([[[SharedClass sharedInstance] selectedMyNewsArr] count]-1)) {
                
                str = [str stringByAppendingString:@","];
                
            }
            
        }
        
        str = [str stringByAppendingString:@")"];
        
        return [self getAllNewsWithSelectedCategories:str];
        
    }
    else if ([[[SharedClass sharedInstance] selectedGenresArr] count] > 0) {
        
        NSIndexPath* indexpath = (NSIndexPath *)[[[SharedClass sharedInstance] selectedGenresArr] objectAtIndex:0];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld.0)",(indexpath.row+1)]];
        
        return [self getAllNewsWithSelectedCategories:str];
        
    }
    
    return [self getAllNews];
    
}


-(NSMutableArray *) getAllNews {
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"SELECT * from NEWS";
        FMResultSet* resultSet = [objectDB executeQuery:query withArgumentsInArray:nil];
        while ([resultSet next]) {
            
            SingleNewsObject* newsObj = [[SingleNewsObject alloc] init];
        
            newsObj.newsId = [resultSet stringForColumnIndex:0];
            newsObj.activeFrom = [resultSet stringForColumnIndex:1];
            newsObj.activeTill = [resultSet stringForColumnIndex:2];
            newsObj.authorId = [resultSet stringForColumnIndex:3];
            newsObj.authorName = [resultSet stringForColumnIndex:4];
            newsObj.dateCreated = [resultSet stringForColumnIndex:5];
            newsObj.dateModified = [resultSet stringForColumnIndex:6];
            newsObj.detailedStory = [resultSet stringForColumnIndex:7];
            newsObj.heading = [resultSet stringForColumnIndex:8];
            newsObj.impactSore = [resultSet stringForColumnIndex:9];
            newsObj.latLng = [resultSet stringForColumnIndex:10];
            newsObj.loc = [resultSet stringForColumnIndex:11];
            newsObj.name = [resultSet stringForColumnIndex:12];
            newsObj.newsImage = [resultSet stringForColumnIndex:13];
            newsObj.newsTimeStamp = [resultSet stringForColumnIndex:14];
            newsObj.subHeading = [resultSet stringForColumnIndex:15];
            newsObj.summary = [resultSet stringForColumnIndex:16];
            newsObj.tags = [resultSet stringForColumnIndex:17];
            newsObj.isLeadStory = [resultSet stringForColumnIndex:18];
            newsObj.isTrending = [resultSet stringForColumnIndex:19];
            
            newsObj.newsComments = [self getAllNewsCommentsForNewsId:newsObj.newsId];
            newsObj.newsGenres = [self getAllNewsGenreForNewsId:newsObj.newsId];
            newsObj.newsInfographics = [self getAllNewsInfographicsForNewsId:newsObj.newsId];;
            
            [arr addObject:newsObj];
            
        }
        [objectDB close];
        
        NSLog(@"NEWS Data fetched Successfully");
        
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
    
    return arr;
    
}

-(NSMutableArray *) getAllNewsWithSelectedCategories:(NSString *)categories {
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= [NSString stringWithFormat:@"SELECT * from NEWS where newsId in (SELECT newsId from NEWSGENRES where genreId in %@)",categories];
        FMResultSet* resultSet = [objectDB executeQuery:query withArgumentsInArray:nil];
        while ([resultSet next]) {
            
            SingleNewsObject* newsObj = [[SingleNewsObject alloc] init];
            
            newsObj.newsId = [resultSet stringForColumnIndex:0];
            newsObj.activeFrom = [resultSet stringForColumnIndex:1];
            newsObj.activeTill = [resultSet stringForColumnIndex:2];
            newsObj.authorId = [resultSet stringForColumnIndex:3];
            newsObj.authorName = [resultSet stringForColumnIndex:4];
            newsObj.dateCreated = [resultSet stringForColumnIndex:5];
            newsObj.dateModified = [resultSet stringForColumnIndex:6];
            newsObj.detailedStory = [resultSet stringForColumnIndex:7];
            newsObj.heading = [resultSet stringForColumnIndex:8];
            newsObj.impactSore = [resultSet stringForColumnIndex:9];
            newsObj.latLng = [resultSet stringForColumnIndex:10];
            newsObj.loc = [resultSet stringForColumnIndex:11];
            newsObj.name = [resultSet stringForColumnIndex:12];
            newsObj.newsImage = [resultSet stringForColumnIndex:13];
            newsObj.newsTimeStamp = [resultSet stringForColumnIndex:14];
            newsObj.subHeading = [resultSet stringForColumnIndex:15];
            newsObj.summary = [resultSet stringForColumnIndex:16];
            newsObj.tags = [resultSet stringForColumnIndex:17];
            newsObj.isLeadStory = [resultSet stringForColumnIndex:18];
            newsObj.isTrending = [resultSet stringForColumnIndex:19];
            
            newsObj.newsComments = [self getAllNewsCommentsForNewsId:newsObj.newsId];
            newsObj.newsGenres = [self getAllNewsGenreForNewsId:newsObj.newsId];
            newsObj.newsInfographics = [self getAllNewsInfographicsForNewsId:newsObj.newsId];;
            
            [arr addObject:newsObj];
            
        }
        [objectDB close];
        
        NSLog(@"NEWS Data fetched Successfully");
        
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
    
    return arr;
    
}


-(void) deleteAllEntriesFromNewsTable {
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"DELETE FROM NEWS";
        if (![objectDB executeUpdate:query withArgumentsInArray:nil]) {
            
            NSLog(@"delete from NEWS failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"NEWS Data deleted Successfully");
        }
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}




#pragma mark - NEWSGENRES TABLE

-(void) insertEntryIntoNewsGenresTableWithGenreArr:(NSMutableArray *)newsGenresArr andNewsId:(NSString *)newsId {
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    
    for (int i = 0; i<newsGenresArr.count; i++) {
        
        NewsGenreObject* obj = [[NewsGenreObject alloc] initWithDictionary:[newsGenresArr objectAtIndex:i] andNewsId:newsId];
        
        NSArray* arr = [NSArray arrayWithObjects: obj.newsGenreId, obj.genre, obj.genreId, obj.newsId, nil];
        
        if ([objectDB open]) {
            NSString* query = @"INSERT INTO NEWSGENRES (newsGenreId, genre, genreId, newsId) VALUES (?, ?, ?, ?)";
            if (![objectDB executeUpdate:query withArgumentsInArray:arr]) {
                
                NSLog(@"insert into NEWSGENRES table failed: %@)",[objectDB lastErrorMessage]);
                
            }
            else {
                NSLog(@"NEWSGENRES Data inserted Successfully");
            }
            
            [objectDB close];
        }
        else {
            NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
        }
        
    }
    
    
}


-(NSMutableArray *) getAllNewsGenreForNewsId:(NSString *)newsId {
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"SELECT * from NEWSGENRES where newsId = ?";
        FMResultSet* resultSet = [objectDB executeQuery:query withArgumentsInArray:[NSArray arrayWithObject:newsId]];
        while ([resultSet next]) {
            
            NewsGenreObject* newsObj = [[NewsGenreObject alloc] init];
            
            newsObj.newsGenreId = [resultSet stringForColumnIndex:0];
            newsObj.genre = [resultSet stringForColumnIndex:1];
            newsObj.genreId = [resultSet stringForColumnIndex:2];
            newsObj.newsId = [resultSet stringForColumnIndex:3];
            
            
            [arr addObject:newsObj];
            
        }
        [objectDB close];
        
        NSLog(@"NEWSGENRES Data fetched Successfully");
        
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
    
    return arr;
    
}

-(void) deleteAllEntriesFromNewsGenreTable {
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"DELETE FROM NEWSGENRES";
        if (![objectDB executeUpdate:query withArgumentsInArray:nil]) {
            
            NSLog(@"delete from NEWSGENRES failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"NEWSGENRES Data deleted Successfully");
        }
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}


#pragma mark - NEWSCOMMENTS TABLE

-(void) insertEntryIntoNewsCommentsTableWithCommentArr:(NSMutableArray *)newsCommentArr andNewsId:(NSString *)newsId {
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    
    for (int i = 0; i<newsCommentArr.count; i++) {
        
        NewsCommentObject* obj = [[NewsCommentObject alloc] initWithDictionary:[newsCommentArr objectAtIndex:i] andNewsId:newsId];
        
        NSArray* arr = [NSArray arrayWithObjects: obj.newsCommentsId, obj.comments, obj.dateCreated, obj.user, obj.newsId, nil];
        
        if ([objectDB open]) {
            NSString* query = @"INSERT INTO NEWSCOMMENTS (newsCommentsId, comments, dateCreated, user, newsId) VALUES (?, ?, ?, ?, ?)";
            if (![objectDB executeUpdate:query withArgumentsInArray:arr]) {
                
                NSLog(@"insert into NEWSCOMMENTS table failed: %@)",[objectDB lastErrorMessage]);
                
            }
            else {
                NSLog(@"NEWSCOMMENTS Data inserted Successfully");
            }
            
            [objectDB close];
        }
        else {
            NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
        }
        
    }
    
    
}

-(NSMutableArray *) getAllNewsCommentsForNewsId:(NSString *)newsId {
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"SELECT * from NEWSCOMMENTS where newsId = ?";
        FMResultSet* resultSet = [objectDB executeQuery:query withArgumentsInArray:[NSArray arrayWithObject:newsId]];
        while ([resultSet next]) {
            
            NewsCommentObject* newsObj = [[NewsCommentObject alloc] init];
            
            newsObj.newsCommentsId = [resultSet stringForColumnIndex:0];
            newsObj.comments = [resultSet stringForColumnIndex:1];
            newsObj.dateCreated = [resultSet stringForColumnIndex:2];
            newsObj.user = [resultSet stringForColumnIndex:3];
            newsObj.newsId = [resultSet stringForColumnIndex:4];
            
            
            [arr addObject:newsObj];
            
        }
        [objectDB close];
        
        NSLog(@"NEWSCOMMENTS Data fetched Successfully");
        
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
    
    return arr;
    
}

-(void) deleteAllEntriesFromNewsCommentTable {
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"DELETE FROM NEWSCOMMENTS";
        if (![objectDB executeUpdate:query withArgumentsInArray:nil]) {
            
            NSLog(@"delete from NEWSCOMMENTS failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"NEWSCOMMENTS Data deleted Successfully");
        }
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}

#pragma mark - NEWSINFOGRAPHICS TABLE

-(void) insertEntryIntoNewsInfographicsTableWithCommentArr:(NSMutableArray *)newsInfographicsArr andNewsId:(NSString *)newsId {
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    
    for (int i = 0; i<newsInfographicsArr.count; i++) {
        
        NewsInfographicsObject* obj = [[NewsInfographicsObject alloc] initWithDictionary:[newsInfographicsArr objectAtIndex:i] andNewsId:newsId];
        
        NSArray* arr = [NSArray arrayWithObjects: obj.newsInfographicsId, obj.newsImage, obj.newsId, nil];
        
        if ([objectDB open]) {
            NSString* query = @"INSERT INTO NEWSINFOGRAPHICS (newsInfographicId, newsImage, newsId) VALUES (?, ?, ?)";
            if (![objectDB executeUpdate:query withArgumentsInArray:arr]) {
                
                NSLog(@"insert into NEWSINFOGRAPHICS table failed: %@)",[objectDB lastErrorMessage]);
                
            }
            else {
                NSLog(@"NEWSINFOGRAPHICS Data inserted Successfully");
            }
            
            [objectDB close];
        }
        else {
            NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
        }
        
    }
    
    
}

-(NSMutableArray *) getAllNewsInfographicsForNewsId:(NSString *)newsId {
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"SELECT * from NEWSINFOGRAPHICS where newsId = ?";
        FMResultSet* resultSet = [objectDB executeQuery:query withArgumentsInArray:[NSArray arrayWithObject:newsId]];
        while ([resultSet next]) {
            
            NewsInfographicsObject* newsObj = [[NewsInfographicsObject alloc] init];
            
            newsObj.newsInfographicsId = [resultSet stringForColumnIndex:0];
            newsObj.newsImage = [resultSet stringForColumnIndex:1];
            newsObj.newsId = [resultSet stringForColumnIndex:2];
            
            
            [arr addObject:newsObj];
            
        }
        [objectDB close];
        
        NSLog(@"NEWSINFOGRAPHICS Data fetched Successfully");
        
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
    
    return arr;
    
}

-(void) deleteAllEntriesFromNewsInfographicsTable {
    NSString* databasePath = [self getDatabasePath];
    FMDatabase* objectDB = [[FMDatabase alloc] initWithPath:databasePath];
    if ([objectDB open]) {
        NSString* query= @"DELETE FROM NEWSINFOGRAPHICS";
        if (![objectDB executeUpdate:query withArgumentsInArray:nil]) {
            
            NSLog(@"delete from NEWSINFOGRAPHICS failed: %@)",[objectDB lastErrorMessage]);
            
        }
        else {
            NSLog(@"NEWSINFOGRAPHICS Data deleted Successfully");
        }
        [objectDB close];
    }
    else {
        NSLog(@"Failed to open/create database: %@)",[objectDB lastErrorMessage]);
    }
}

@end
