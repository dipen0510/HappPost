//
//  SingleNewsObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleNewsObject : NSObject

@property (nonatomic, strong) NSString* activeFrom;
@property (nonatomic, strong) NSString* activeTill;
@property (nonatomic, strong) NSString* authorId;
@property (nonatomic, strong) NSString* authorName;
@property (nonatomic, strong) NSString* dateCreated;
@property (nonatomic, strong) NSString* dateModified;
@property (nonatomic, strong) NSString* detailedStory;
@property (nonatomic, strong) NSString* heading;
@property (nonatomic, strong) NSString* impactSore;
@property (nonatomic, strong) NSString* latLng;
@property (nonatomic, strong) NSString* loc;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableArray* newsComments;
@property (nonatomic, strong) NSMutableArray* newsGenres;
@property (nonatomic, strong) NSString* newsId;
@property (nonatomic, strong) NSString* newsImage;
@property (nonatomic, strong) NSMutableArray* newsInfographics;
@property (nonatomic, strong) NSString* newsTimeStamp;
@property (nonatomic, strong) NSString* subHeading;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSString* tags;
@property (nonatomic, strong) NSString* isLeadStory;
@property (nonatomic, strong) NSString* isTrending;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
