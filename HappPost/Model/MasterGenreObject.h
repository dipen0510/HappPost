//
//  MasterGenreObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 23/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterGenreObject : NSObject

@property (nonatomic, strong) NSString* active;
@property (nonatomic, strong) NSString* genreId;
@property (nonatomic, strong) NSString* dateCreated;
@property (nonatomic, strong) NSString* name;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
