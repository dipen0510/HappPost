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
    [self enablePushNotification];
    
    //Check if App starts because of push notification
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil)
    {
        
    }
    
    [[GoogleAnalyticsHelper sharedInstance] sendEventWithCategory:@"iOS Event Category" andAction:@"iOS App Launched" andLabel:@"iOS App Launched"];
    
    return YES;
}

// Add or incorporate this function in your app delegate file
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    //NSLog(@"Succeeded registering for push notifications. Device token: %@", devToken);
    
    NSString *tokenStr = [devToken description];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:tokenStr forKey:kDeviceToken];
    
}

//Add or incorporate function to display for simulator support
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    //NSLog(@"Failed to register with error: %@", error);
    
}

// Add or incorporate this function in your app delegate file
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)launchOptions
{
    //NSLog(@"Receiving notification, app is running");
    
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


#pragma mark - PUSH NOTIFICATION TOGGLE

- (void)enablePushNotification {
    UIApplication * app = [UIApplication sharedApplication];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    
    if([app respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [app registerUserNotificationSettings: settings];
        [app registerForRemoteNotifications];
    }
    else
    {
#endif
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert;
        [app registerForRemoteNotificationTypes:types];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    }
#endif
    
}


@end
