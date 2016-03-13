//
//  GetAdDataResponseObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 13/03/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import "GetAdDataResponseObject.h"

@implementation GetAdDataResponseObject

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self == nil) return nil;
    
    _listAdData = dictionary[ListAdDataKey];
    
    return self;
}

@end
