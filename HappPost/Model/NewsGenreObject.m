//
//  NewsGenreObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 30/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "NewsGenreObject.h"

@implementation NewsGenreObject

- (id)initWithDictionary:(NSDictionary *)dictionary andNewsId:(NSString *)newsMapId {
    
    self = [self init];
    if (self == nil) return nil;
    
    _genre = dictionary[GenreKey];
    _genreId = dictionary[GenreIdKey];
    _newsGenreId = dictionary[NewsGenreIdKey];
    _newsId = newsMapId;
    
    return self;
    
}

@end
