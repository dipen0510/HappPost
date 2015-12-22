//
//  MasterGenreObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 23/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "MasterGenreObject.h"

@implementation MasterGenreObject

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [self init];
    if (self == nil) return nil;
    
    _active = dictionary[ActiveKey];
    _dateCreated = dictionary[DateCreatedKey];
    _genreId = dictionary[MasterGenreIdKey];
    _name = dictionary[NameKey];
    
    return self;
    
}

@end
