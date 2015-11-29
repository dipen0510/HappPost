//
//  NewsContentRequestObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsContentRequestObject : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* timestamp;

- (NSMutableDictionary *)createRequestDictionary;

@end
