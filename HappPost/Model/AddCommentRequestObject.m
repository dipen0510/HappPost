//
//  AddCommentRequestObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 06/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "AddCommentRequestObject.h"

@implementation AddCommentRequestObject

@synthesize userId,newsId,comments;

- (NSMutableDictionary *)createRequestDictionary {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:userId forKey:userIdKey];
    [dict setObject:newsId forKey:NewsIdKey];
    [dict setObject:comments forKey:CommentsKey];
    
    return dict;
}

@end
