//
//  VerifyRequestObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 10/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "VerifyRequestObject.h"

@implementation VerifyRequestObject

@synthesize userId,code;

- (NSMutableDictionary *)createRequestDictionary {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:userId forKey:idKey];
    [dict setObject:code forKey:CodeKey];
    
    return dict;
}

@end
