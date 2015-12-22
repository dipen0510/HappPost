//
//  SplashViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "SplashViewController.h"
#import "NewsContentResponseObject.h"
#import "NewsContentRequestObject.h"
#import "RegisterRequestObject.h"
#import "RegisterResponseObject.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SharedClass sharedInstance] setSelectedGenresArr:[[NSMutableArray alloc] init]];
    
    
    if ([self needsUpdate]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update is available" message:@"A new version of this application is available." delegate:self cancelButtonTitle:@"Update" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else {
        
        if ([[SharedClass sharedInstance] userId]) {
            
            [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
            
        }
        else {
            
            [self startSkipRegistrationService];
            
        }
        
    }

    
}


-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    if (data) {
        NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([lookup[@"resultCount"] integerValue] == 1){
            NSString* appStoreVersion = lookup[@"results"][0][@"version"];
            NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
            if (![appStoreVersion isEqualToString:currentVersion]){
                NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
                return YES;
            }
        }
    }
    
    
    return NO;
}


- (void) startSkipRegistrationService {
    
    [SVProgressHUD showWithStatus:@"Preparing app for its first time use"];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kSkipRegistrationService;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForSkipregistration]];
    
}

-(void) startGetNewsContentService {
    
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetNewsContent;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForNewsContent]];
    
}

-(void) startGetGenresContentService {
    
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetMasterGenreList;
    manager.delegate = self;
    [manager startGETWebServicesWithBaseURL];
    
}


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(RegisterResponseObject *)responseData andServiceKey:(NSString *)requestServiceKey {
    
    
    if ([requestServiceKey isEqualToString:kSkipRegistrationService]) {
        
        [[SharedClass sharedInstance] setUserId:responseData.userId];
        [[SharedClass sharedInstance] setUserRegisterDetails:registerObj];
        
        [[DBManager sharedManager] insertEntryIntoUserTableWithUserId:responseData.userId andOtherUserDetails:registerObj];
        
        [self startGetGenresContentService];
        
    }
    
    if ([requestServiceKey isEqualToString:kGetMasterGenreList]) {
        
        [self startGetNewsContentService];
        
    }
    
}


-(void) didFinishServiceWithFailure:(NSString *)errorMsg {
    
    [SVProgressHUD dismiss];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Server error"
                                                  message:@"Request timed out, please try again later."
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles: nil];
    
    if (![errorMsg isEqualToString:@""]) {
        [alert setMessage:errorMsg];
    }
    
    [alert show];
    
    return;
    
}

-(void) didUpdateLatestNewsContent {
    
    [SVProgressHUD showSuccessWithStatus:@"News Updated"];
    [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
    
}

#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForSkipregistration {
    
    registerObj = [[RegisterRequestObject alloc] init];
    registerObj.email = @"";
    registerObj.name = @"";
    registerObj.deviceId = @"111";
    registerObj.deviceTypeId = iOSDeviceType;
    registerObj.gcmId = @"222";
    registerObj.ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return [registerObj createRequestDictionary];
    
}

- (NSMutableDictionary *) prepareDictionaryForNewsContent {
    
    NewsContentRequestObject* requestObj = [[NewsContentRequestObject alloc] init];
    requestObj.userId = [[SharedClass sharedInstance] userId];
    requestObj.timestamp = @"";
    
    return [requestObj createRequestDictionary];
    
}


#pragma mark - Alertview Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSString *iTunesLink = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=%@&mt=8",kAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
