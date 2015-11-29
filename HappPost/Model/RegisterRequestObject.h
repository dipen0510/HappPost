//
//  RegisterRequestObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 19/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterRequestObject : NSObject

@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* deviceId;
@property (nonatomic, strong) NSString* deviceTypeId;
@property (nonatomic, strong) NSString* gcmId;
@property (nonatomic, strong) NSString* ver;

- (NSMutableDictionary *)createRequestDictionary;

@end
