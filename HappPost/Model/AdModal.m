//
//  AdModal.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 13/03/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import "AdModal.h"

@implementation AdModal

#pragma mark - Init

+ (instancetype)modelWithNews:(NSMutableDictionary *)adObj {
    return [[self alloc] initWithObj:adObj];
}

- (instancetype)initWithObj:(NSMutableDictionary *)adObj {
    if (self = [super init]) {
        
        _adId = adObj[AdIdKey];
        _count = adObj[CountKey];
        _adImage = adObj[AdImageKey];
        _adLink = adObj[AdLinkKey];
        _adName = adObj[AdNameKey];
        _adType = adObj[AdTypeKey];
        
        
    }
    
    return self;
}

@end
