//
//  GetAdDataRequestObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 13/03/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import "GetAdDataRequestObject.h"

@implementation GetAdDataRequestObject

@synthesize timeStamp;

- (NSMutableDictionary *)createRequestDictionary {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:timeStamp forKey:timestampForGetNewsKey];
    
    return dict;
}

@end
