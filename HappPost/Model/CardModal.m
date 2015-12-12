//
//  CardModal.m
//  CoverFlowLayoutDemo
//
//  Created by Dipen Sekhsaria on 3/13/15.
//  Copyright (c) 2015 solomidSF. All rights reserved.
//

#import "CardModal.h"

@implementation CardModal

#pragma mark - Init

+ (instancetype)modelWithNews:(SingleNewsObject *)newsObj {
    return [[self alloc] initWithObj:newsObj];
}

- (instancetype)initWithObj:(SingleNewsObject *)newsObj {
    if (self = [super init]) {
        
        _heading = newsObj.heading;
        _subheading = newsObj.subHeading;
        _summary = newsObj.summary;
        _author = newsObj.authorName;
        _imgURL = newsObj.webImage;
        _headlineColor = newsObj.headlineColor;
        _newsId = newsObj.newsId;
        _dateTime = [[[SharedClass sharedInstance] dateFromString:newsObj.dateCreated] timeAgo];
        
    }
    
    return self;
}


@end
