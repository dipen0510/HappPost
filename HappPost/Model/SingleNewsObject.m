//
//  SingleNewsObject.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "SingleNewsObject.h"

@implementation SingleNewsObject


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self == nil) return nil;
    
    _activeFrom = dictionary[ActiveFromKey];
    _activeTill = dictionary[ActiveTillKey];
    _authorId = dictionary[AuthorIdKey];
    _authorName = dictionary[AuthorNameKey];
    _dateCreated = dictionary[DateCreatedKey];
    _dateModified = dictionary[DateModifiedKey];
    _detailedStory = dictionary[DetailedStoryKey];
    _heading = dictionary[HeadingKey];
    _impactSore = dictionary[ImpactSoreKey];
    _latLng = dictionary[LatLngKey];
    _loc = dictionary[LocKey];
    _name = dictionary[NameKey];
    _newsComments = dictionary[NewsCommentsKey];
    _newsGenres = dictionary[NewsGenresKey];
    _newsId = dictionary[NewsIdKey];
    _newsImage = dictionary[NewsImageKey];
    _newsInfographics = dictionary[NewsInfographicsKey];
    _newsTimeStamp = dictionary[NewsTimeStampKey];
    _subHeading = dictionary[SubHeadingKey];
    _summary = dictionary[SummaryKey];
    _tags = dictionary[TagsKey];
    _isLeadStory = dictionary[isLeadStoryKey];
    _isTrending = dictionary[isTrendingKey];
    _headlineColor = dictionary[HeadlineColorKey];
    _secondLeadImage = dictionary[SecondLeadImageKey];
    _webImage = dictionary[WebImageKey];
    
    _activeFromDate = [[SharedClass sharedInstance] sqlLiteFormattedDateStringFromResponseString:_activeFrom];
    
    if (_activeTill && !([_activeTill isEqual:[NSNull null]])) {
        _activeTillDate = [[SharedClass sharedInstance] sqlLiteFormattedDateStringFromResponseString:_activeTill];
    }
    else {
        _activeTillDate = @"a";
    }
    
    
    return self;
}


@end
