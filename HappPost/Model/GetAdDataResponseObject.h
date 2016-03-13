//
//  GetAdDataResponseObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 13/03/16.
//  Copyright © 2016 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAdDataResponseObject : NSObject

@property (nonatomic, strong) NSMutableArray* listAdData;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
