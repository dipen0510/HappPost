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

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[SharedClass sharedInstance] userId]) {
        
        [self startGetNewsContentService];
        
    }
    else {
        
        [self performSegueWithIdentifier:@"showRegisterSegue" sender:nil];
        
    }
    
}


#pragma mark - API Handling

-(void) startGetNewsContentService {
    
    [SVProgressHUD showWithStatus:@"Fetching latest news"];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetNewsContent;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForNewsContent]];
    
}

#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(NewsContentResponseObject *)responseData andServiceKey:(NSString *)requestServiceKey {
    
        if ([requestServiceKey isEqualToString:kGetNewsContent]) {
    
            [[SharedClass sharedInstance] insertNewsContentResponseIntoDB:responseData];
            
            [SVProgressHUD dismiss];
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

- (NSMutableDictionary *) prepareDictionaryForNewsContent {
    
    NewsContentRequestObject* requestObj = [[NewsContentRequestObject alloc] init];
    requestObj.userId = [[SharedClass sharedInstance] userId];
    requestObj.timestamp = [[[DBManager sharedManager] getAllSettings] valueForKey:timestampKey];
    
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
