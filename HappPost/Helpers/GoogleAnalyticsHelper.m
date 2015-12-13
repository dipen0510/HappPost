//
//  GoogleAnalyticsHelper.m
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 26/11/15.
//  Copyright © 2015 ProcterAndGamble. All rights reserved.
//

#import "GoogleAnalyticsHelper.h"

@implementation GoogleAnalyticsHelper

static GoogleAnalyticsHelper *singletonObject = nil;

+ (id) sharedInstance
{
    if (! singletonObject) {
        
        singletonObject = [[GoogleAnalyticsHelper alloc] init];
    }
    return singletonObject;
}

- (id)init
{
    if (! singletonObject) {
        
        singletonObject = [super init];
        // Uncomment the following line to see how many times is the init method of the class is called
         NSLog(@"%s", __PRETTY_FUNCTION__);
        
        // Configure tracker from GoogleService-Info.plist.
        NSError *configureError;
        [[GGLContext sharedInstance] configureWithError:&configureError];
        NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
        
        // Optional: configure GAI options.
        gai = [GAI sharedInstance];
        gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
        //gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
        
        // May return nil if a tracker has not already been initialized with a property
        // ID.
        tracker = [[GAI sharedInstance] defaultTracker];
        
    }
    return singletonObject;
}

- (void) sendEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label {
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label          // Event label
                                                           value:nil] build]];    // Event value
    
}

- (void) sendScreenTrackingWithName:(NSString *)screenName {
    
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

//- (void) sendTimeTakenWithCategory:(NSString *)category andName:(NSString *)name andLabel:(NSString *)label {
//    
//    // May return nil if a tracker has not already been initialized with a
//    // property ID.
//    
//    NSTimeInterval loadTime = [[[SharedClass sharedInstance] scanFinishTime] timeIntervalSinceDate:[[SharedClass sharedInstance] scanStartTime]];
//    
//    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category                      // Timing category (required)
//                                                         interval:@((NSUInteger)(loadTime * 1000))   // Timing interval (required)
//                                                             name:name                     // Timing name
//                                                            label:label] build]];                      // Timing label
//}

@end
