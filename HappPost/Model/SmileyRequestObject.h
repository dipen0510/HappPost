//
//  SmileyRequestObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 18/01/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmileyRequestObject : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* newsId;

- (NSMutableDictionary *)createRequestDictionary;

@end
