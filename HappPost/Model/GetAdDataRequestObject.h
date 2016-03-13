//
//  GetAdDataRequestObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 13/03/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAdDataRequestObject : NSObject

@property (nonatomic, strong) NSString* timeStamp;

- (NSMutableDictionary *)createRequestDictionary;

@end
