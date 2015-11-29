//
//  NewsContentRequestObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "NewsContentRequestObject.h"

@implementation NewsContentRequestObject

@synthesize userId,timestamp;

- (NSMutableDictionary *)createRequestDictionary {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:userId forKey:userIdKey];
    [dict setObject:timestamp forKey:timestampKey];
    
    return dict;
}

@end
