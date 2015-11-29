//
//  NewsCommentObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 30/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "NewsCommentObject.h"

@implementation NewsCommentObject

- (id)initWithDictionary:(NSDictionary *)dictionary andNewsId:(NSString *)newsMapId {
    
    self = [self init];
    if (self == nil) return nil;
    
    _comments = dictionary[CommentsKey];
    _dateCreated = dictionary[DateCreatedKey];
    _newsCommentsId = dictionary[NewsCommentsIdKey];
    _user = dictionary[UserKey];
    _newsId = newsMapId;
    
    return self;
    
}

@end
