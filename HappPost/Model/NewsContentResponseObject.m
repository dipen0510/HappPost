//
//  NewsContentResponseObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "NewsContentResponseObject.h"

@implementation NewsContentResponseObject

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self == nil) return nil;
    
    _newsDataInfo = dictionary[newsDataInfoKey];
    _timeStamp = dictionary[timestampKey];
    _notificationSetting = dictionary[notificationSettingKey];
    
    return self;
}

@end
