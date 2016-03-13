//
//  AdModal.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 13/03/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModal : NSObject

@property (nonatomic, readonly) NSString *adId;
@property (nonatomic, readonly) NSString *count;
@property (nonatomic, readonly) NSString *adImage;
@property (nonatomic, readonly) NSString *adLink;
@property (nonatomic, readonly) NSString *adName;
@property (nonatomic, readonly) NSString *adType;

+ (instancetype)modelWithNews:(NSMutableDictionary *)adObj;

@end
