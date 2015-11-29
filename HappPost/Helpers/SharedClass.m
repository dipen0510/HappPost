//
//  SharedClass.m
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 03/11/15.
//  Copyright © 2015 ProcterAndGamble. All rights reserved.
//

#import "SharedClass.h"
#import "NewsContentResponseObject.h"

@implementation SharedClass

@synthesize userId,userRegisterDetails;

static SharedClass *singletonObject = nil;

+ (id) sharedInstance
{
    if (! singletonObject) {
        
        singletonObject = [[SharedClass alloc] init];
    }
    return singletonObject;
}

- (id)init
{
    if (! singletonObject) {
        
        singletonObject = [super init];
        // Uncomment the following line to see how many times is the init method of the class is called
        // NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return singletonObject;
}

-(NSDate* )getCurrentUTCFormatDate
{
    
    NSDate* localDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    NSDate* utcDate = [dateFormatter dateFromString:dateString];
    
    return utcDate;
}


- (void) insertNewsContentResponseIntoDB: (NewsContentResponseObject *)newsObj {
    
    [[DBManager sharedManager] insertEntryIntoSettingsTableWithTimeStamp:newsObj.timeStamp andNotificationSetting:newsObj.notificationSetting];
    
    for (int i = 0; i<newsObj.newsDataInfo.count ; i++) {
        
        SingleNewsObject* singleNewsObj = [[SingleNewsObject alloc] initWithDictionary:[newsObj.newsDataInfo objectAtIndex:i]];
        
        [[DBManager sharedManager] insertEntryIntoNewsTableWithObj:singleNewsObj];
        [[DBManager sharedManager] insertEntryIntoNewsCommentsTableWithCommentArr:singleNewsObj.newsComments andNewsId:singleNewsObj.newsId];
        [[DBManager sharedManager] insertEntryIntoNewsGenresTableWithGenreArr:singleNewsObj.newsGenres andNewsId:singleNewsObj.newsId];
        
    }
    
    
}



@end
