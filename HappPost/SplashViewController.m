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
    
    [[SharedClass sharedInstance] setSelectedMyNewsArr:[[NSMutableArray alloc] init]];
    [[SharedClass sharedInstance] setSelectedGenresArr:[[NSMutableArray alloc] init]];
    
    if ([[SharedClass sharedInstance] userId]) {
        
        [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
        
    }
    else {
        
        [self performSegueWithIdentifier:@"showRegisterSegue" sender:nil];
        
    }
    
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
