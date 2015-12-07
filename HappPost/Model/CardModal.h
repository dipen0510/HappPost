//
//  CardModal.h
//  CoverFlowLayoutDemo
//
//  Created by Dipen Sekhsaria on 3/13/15.
//  Copyright (c) 2015 solomidSF. All rights reserved.
//

@import UIKit;

/**
 *  Simple photo model that acts as a datasource for collection view.
 */
@interface CardModal : NSObject

@property (nonatomic, readonly) NSString *newsId;
@property (nonatomic, readonly) NSString *imgURL;
@property (nonatomic, readonly) NSString *heading;
@property (nonatomic, readonly) NSString *subheading;
@property (nonatomic, readonly) NSString *author;
@property (nonatomic, readonly) NSString *summary;
@property (nonatomic, readonly) NSString *dateTime;
@property (nonatomic, readonly) NSString *headlineColor;

+ (instancetype)modelWithNews:(SingleNewsObject *)newsObj;

@end
