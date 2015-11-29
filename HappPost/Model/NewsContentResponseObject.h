//
//  NewsContentResponseObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsContentResponseObject : NSObject

@property (nonatomic, strong) NSString* notificationSetting;
@property (nonatomic, strong) NSString* timeStamp;
@property (nonatomic, strong) NSMutableArray* newsDataInfo;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
