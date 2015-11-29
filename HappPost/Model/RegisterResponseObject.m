//
//  RelayLoginResponseObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 20/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "RegisterResponseObject.h"

@implementation RegisterResponseObject

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self == nil) return nil;
    
    _userId = dictionary[idKey];
    _status = dictionary[statusKey];
    
    return self;
}

@end
