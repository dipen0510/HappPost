//
//  RegisterViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "RegisterViewController.h"
#import "NewsContentRequestObject.h"
#import "NewsContentResponseObject.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerButtonTapped:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Registering..."];
    [self startRegisterService];
    
}

- (IBAction)skipForNowButtonTapped:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Processing..."];
    [self startSkipRegistrationService];
    
}

#pragma mark - API Handling

- (void) startRegisterService {
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kRegisterService;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForRegister]];
    
}

- (void) startSkipRegistrationService {
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kSkipRegistrationService;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForSkipregistration]];
    
}

-(void) startGetNewsContentService {
    
    [SVProgressHUD showWithStatus:@"Fetching latest news"];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetNewsContent;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForNewsContent]];
    
}

#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(RegisterResponseObject *)responseData andServiceKey:(NSString *)requestServiceKey {
    
    
    if ([requestServiceKey isEqualToString:kRegisterService] || [requestServiceKey isEqualToString:kSkipRegistrationService]) {
        
        [[SharedClass sharedInstance] setUserId:responseData.userId];
        [[SharedClass sharedInstance] setUserRegisterDetails:registerObj];
        
        [[DBManager sharedManager] insertEntryIntoUserTableWithUserId:responseData.userId andOtherUserDetails:registerObj];
        
        [SVProgressHUD dismiss];
        
        [self startGetNewsContentService];
        
    }
    
    if ([requestServiceKey isEqualToString:kGetNewsContent]) {
        
        [SVProgressHUD showSuccessWithStatus:@"News Updated"];
        [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
        
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

#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForRegister {
    
    registerObj = [[RegisterRequestObject alloc] init];
    registerObj.email = self.usernameTxtField.text;
    registerObj.name = self.nameTxtField.text;
    registerObj.deviceId = @"111";
    registerObj.deviceTypeId = iOSDeviceType;
    registerObj.gcmId = @"222";
    registerObj.ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return [registerObj createRequestDictionary];
    
}

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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
