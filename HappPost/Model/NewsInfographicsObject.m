//
//  NewsInfographicsObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 04/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "NewsInfographicsObject.h"

@implementation NewsInfographicsObject

- (id)initWithDictionary:(NSDictionary *)dictionary andNewsId:(NSString *)newsMapId {
    
    self = [self init];
    if (self == nil) return nil;
    
    _newsInfographicsId = dictionary[NewsInfographicsIdKey];
    _newsImage = dictionary[NewsImageKey];
    _newsId = newsMapId;
    
    return self;
    
}

@end
