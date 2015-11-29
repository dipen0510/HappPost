//
//  NewsCommentObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 30/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCommentObject : NSObject

@property (nonatomic, strong) NSString* newsCommentsId;
@property (nonatomic, strong) NSString* user;
@property (nonatomic, strong) NSString* comments;
@property (nonatomic, strong) NSString* dateCreated;
@property (nonatomic, strong) NSString* newsId;

- (id)initWithDictionary:(NSDictionary *)dictionary andNewsId:(NSString *)newsMapId;

@end
