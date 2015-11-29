//
//  NewsGenreObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 30/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsGenreObject : NSObject

@property (nonatomic, strong) NSString* genre;
@property (nonatomic, strong) NSString* genreId;
@property (nonatomic, strong) NSString* newsGenreId;
@property (nonatomic, strong) NSString* newsId;

- (id)initWithDictionary:(NSDictionary *)dictionary andNewsId:(NSString *)newsMapId;

@end
