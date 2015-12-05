//
//  SharedClass.h
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 03/11/15.
//  Copyright © 2015 ProcterAndGamble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterRequestObject.h"
#import "NewsContentResponseObject.h"

@interface SharedClass : NSObject

+ sharedInstance;

@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) RegisterRequestObject* userRegisterDetails;

-(NSDate *)getCurrentUTCFormatDate;
- (void) insertNewsContentResponseIntoDB: (NewsContentResponseObject *)newsObj;
- (NSDate *) dateFromString:(NSString *)dateTime;

@end
