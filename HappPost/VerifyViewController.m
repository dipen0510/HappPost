//
//  VerifyViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 10/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "VerifyViewController.h"
#import "VerifyRequestObject.h"


@interface VerifyViewController ()

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonTapped:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Verifying..."];
    [self startRegisterService];
    
}



#pragma mark - API Handling

- (void) startRegisterService {
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kVerifyService;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForRegister]];
    
}




#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(id)responseData andServiceKey:(NSString *)requestServiceKey {
    
    
    if ([requestServiceKey isEqualToString:kVerifyService]) {
        
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
        
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
    
    VerifyRequestObject* requestObj = [[VerifyRequestObject alloc] init];
    requestObj.code = self.usernameTxtField.text;
    requestObj.userId = [[SharedClass sharedInstance] userId];
    
    return [registerObj createRequestDictionary];
    
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
