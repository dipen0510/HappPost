//
//  VerifyRequestObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 10/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyRequestObject : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* code;

- (NSMutableDictionary *)createRequestDictionary;

@end
