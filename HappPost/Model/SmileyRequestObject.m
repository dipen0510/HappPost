//
//  SmileyRequestObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 18/01/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import "SmileyRequestObject.h"

@implementation SmileyRequestObject

@synthesize userId,newsId;

- (NSMutableDictionary *)createRequestDictionary {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:userId forKey:userIdKey];
    [dict setObject:newsId forKey:NewsIdKey];
    
    return dict;
}

@end
