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
    
    [[SharedClass sharedInstance] setSelectedMyNewsArr:[[NSMutableArray alloc] init]];
    [[SharedClass sharedInstance] setSelectedGenresArr:[[NSMutableArray alloc] init]];
    
    if ([[SharedClass sharedInstance] userId]) {
        
        [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
        
    }
    else {
        
        [self startSkipRegistrationService];
        
    }
    
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


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(RegisterResponseObject *)responseData andServiceKey:(NSString *)requestServiceKey {
    
    
    if ([requestServiceKey isEqualToString:kSkipRegistrationService]) {
        
        [[SharedClass sharedInstance] setUserId:responseData.userId];
        [[SharedClass sharedInstance] setUserRegisterDetails:registerObj];
        
        [[DBManager sharedManager] insertEntryIntoUserTableWithUserId:responseData.userId andOtherUserDetails:registerObj];
        
        [self startGetNewsContentService];
        
    }
    
    if ([requestServiceKey isEqualToString:kGetNewsContent]) {
        
        [SVProgressHUD showSuccessWithStatus:@"News Updated"];
        
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
