//
//  SplashViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "SplashViewController.h"
#import "GetAdDataRequestObject.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SharedClass sharedInstance] setSelectedGenresArr:[[NSMutableArray alloc] init]];
    
    [self startGetAdService];
    
    if ([self needsUpdate]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Update is available" message:@"A new version of this application is available." delegate:self cancelButtonTitle:@"Update" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else {
        
        if ([[SharedClass sharedInstance] userId]) {
            
            [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
            
        }
        else {
            
            [self performSegueWithIdentifier:@"showTutorialSegue" sender:nil];
            
        }
        
    }

    
}

- (void) startGetAdService {
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetAdData;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForGetAd]];
    
}

#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForGetAd {
    
    GetAdDataRequestObject* registerObj = [[GetAdDataRequestObject alloc] init];
    registerObj.timeStamp = [[[SharedClass sharedInstance] getUTCDateFormatter] stringFromDate:[NSDate date]];
    
    return [registerObj createRequestDictionary];
    
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
            if ([currentVersion compare:appStoreVersion] == NSOrderedAscending){
                NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
                return YES;
            }
        }
    }
    
    
    return NO;
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
