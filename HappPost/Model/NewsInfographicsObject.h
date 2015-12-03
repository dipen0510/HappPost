//
//  NewsInfographicsObject.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 04/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfographicsObject : NSObject

@property (nonatomic, strong) NSString* newsInfographicsId;
@property (nonatomic, strong) NSString* newsImage;
@property (nonatomic, strong) NSString* newsId;

- (id)initWithDictionary:(NSDictionary *)dictionary andNewsId:(NSString *)newsMapId;

@end
