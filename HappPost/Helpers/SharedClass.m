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

@synthesize userId,userRegisterDetails,selectedMyNewsArr,selectedGenresArr,menuOptionType,searchText;

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
    
    NSMutableArray* insertArr = [[NSMutableArray alloc] init];
    NSMutableArray* deleteArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<newsObj.newsDataInfo.count; i++) {
        
        if ([[[newsObj.newsDataInfo objectAtIndex:i] valueForKey:ActiveKey] boolValue]) {
            [insertArr addObject:[newsObj.newsDataInfo objectAtIndex:i]];
        }
        else {
            [deleteArr addObject:[newsObj.newsDataInfo objectAtIndex:i]];
        }
        
    }
    
    for (int i = 0; i<insertArr.count ; i++) {
        
        SingleNewsObject* singleNewsObj = [[SingleNewsObject alloc] initWithDictionary:[insertArr objectAtIndex:i]];
        
        [[DBManager sharedManager] insertEntryIntoNewsTableWithObj:singleNewsObj];
        [[DBManager sharedManager] insertEntryIntoNewsCommentsTableWithCommentArr:singleNewsObj.newsComments andNewsId:singleNewsObj.newsId];
        [[DBManager sharedManager] insertEntryIntoNewsGenresTableWithGenreArr:singleNewsObj.newsGenres andNewsId:singleNewsObj.newsId];
        [[DBManager sharedManager] insertEntryIntoNewsInfographicsTableWithCommentArr:singleNewsObj.newsInfographics andNewsId:singleNewsObj.newsId];
        
    }
    
    for (int i = 0; i<deleteArr.count ; i++) {
        
        SingleNewsObject* singleNewsObj = [[SingleNewsObject alloc] initWithDictionary:[deleteArr objectAtIndex:i]];
        
        [[DBManager sharedManager] deleteNewsWithNewsId:singleNewsObj.newsId];
        
    }
    
    
}

- (NSDate *) dateFromString:(NSString *)dateTime {
    
    dateTime = [dateTime stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    
    NSArray* dateArr = [dateTime componentsSeparatedByString:@" "];
    
    int day = [[dateArr objectAtIndex:1] intValue];
    int month = [self monthForString:[dateArr objectAtIndex:0]];
    int year = [[dateArr objectAtIndex:2] intValue];
    
    int hour = 0;
    int minute  = 0;
    
    if ([[dateArr lastObject] containsString:@"AM"]) {
        NSString* time = [[dateArr lastObject] stringByReplacingOccurrencesOfString:@"AM" withString:@""];
        hour = [[[time componentsSeparatedByString:@":"] firstObject] intValue];
        minute = [[[time componentsSeparatedByString:@":"] lastObject] intValue];
    }
    else {
        NSString* time = [[dateArr lastObject] stringByReplacingOccurrencesOfString:@"PM" withString:@""];
        hour = [[[time componentsSeparatedByString:@":"] firstObject] intValue] + 12;
        minute = [[[time componentsSeparatedByString:@":"] lastObject] intValue];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    
    return [calendar dateFromComponents:components];
    
}


- (NSString *) sqlLiteFormattedDateStringFromResponseString:(NSString *)str {
    
    NSDate* date = [self dateFromString:str];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strTime = [objDateformat stringFromDate:date];
    
    return strTime;
    
}

- (NSString *) sqlLiteFormattedCurrentDate {
    
    NSDate* date = [NSDate date];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strTime = [objDateformat stringFromDate:date];
    
    return strTime;
    
}


- (int) monthForString:(NSString *)month {
    
    if ([month isEqualToString:@"Jan"]) {
        return 1;
    }
    else if ([month isEqualToString:@"Feb"]) {
        return 2;
    }
    else if ([month isEqualToString:@"Mar"]) {
        return 3;
    }
    else if ([month isEqualToString:@"Apr"]) {
        return 4;
    }
    else if ([month isEqualToString:@"May"]) {
        return 5;
    }
    else if ([month isEqualToString:@"Jun"]) {
        return 6;
    }
    else if ([month isEqualToString:@"Jul"]) {
        return 7;
    }
    else if ([month isEqualToString:@"Aug"]) {
        return 8;
    }
    else if ([month isEqualToString:@"Sep"]) {
        return 9;
    }
    else if ([month isEqualToString:@"Oct"]) {
        return 10;
    }
    else if ([month isEqualToString:@"Nov"]) {
        return 11;
    }
    return 12;
    
    
}



@end
