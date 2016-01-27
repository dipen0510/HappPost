//
//  GoogleAnalyticsHelper.h
//  Happ Post
//
//  Created by Dipen Sekhsaria on 26/11/15.
//  Copyright © 2015 Stardeep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAnalyticsHelper : NSObject {
    GAI *gai;
    id<GAITracker> tracker;
}

+ sharedInstance;

- (void) sendEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label;
- (void) sendScreenTrackingWithName:(NSString *)screenName;
//- (void) sendTimeTakenWithCategory:(NSString *)category andName:(NSString *)name andLabel:(NSString *)label;

@end
