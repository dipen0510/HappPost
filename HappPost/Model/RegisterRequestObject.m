//
//  RegisterRequestObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 19/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "RegisterRequestObject.h"

@implementation RegisterRequestObject

@synthesize email,name,deviceId,deviceTypeId,ver,gcmId;

- (NSMutableDictionary *)createRequestDictionary {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:email forKey:emailKey];
    [dict setObject:name forKey:nameKey];
    [dict setObject:deviceId forKey:deviceIdKey];
    [dict setObject:deviceTypeId forKey:deviceTypeIdKey];
    [dict setObject:gcmId forKey:gcmIdKey];
    [dict setObject:ver forKey:verKey];
    
    return dict;
}

@end
