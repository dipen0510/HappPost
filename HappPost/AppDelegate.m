//
//  AppDelegate.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 17/11/15.
//  Copyright (c) 2015 Star Deep. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[DBManager sharedManager] setupDatabase];
    [[DBManager sharedManager] getAllUserDetailsAndStoreInSharedClass];
    
    [self checkAndLoadMyNewsCategories];
    
    [[GoogleAnalyticsHelper sharedInstance] sendEventWithCategory:@"iOS Event Category" andAction:@"iOS App Launched" andLabel:@"iOS App Launched"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self saveMyNewsCategories];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self checkAndLoadMyNewsCategories];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self saveMyNewsCategories];
    
}


- (void) checkAndLoadMyNewsCategories {

    NSMutableArray* arr = [[NSMutableArray alloc] init];
    arr = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:myNewsUserDefaultsKey];
    
    if (arr) {
        [[SharedClass sharedInstance] setSelectedMyNewsArr:arr];
    }
    
}

- (void) saveMyNewsCategories {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[[SharedClass sharedInstance] selectedMyNewsArr] forKey:myNewsUserDefaultsKey];
    
}


@end
