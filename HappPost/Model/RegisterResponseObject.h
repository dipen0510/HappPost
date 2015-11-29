//
//  RelayLoginResponseObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 20/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterResponseObject : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* status;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
