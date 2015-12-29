//
//  AddCommentRequestObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 06/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddCommentRequestObject : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* newsId;
@property (nonatomic, strong) NSString* dateAndTime;
@property (nonatomic, strong) NSString* comments;

- (NSMutableDictionary *)createRequestDictionary;

@end
