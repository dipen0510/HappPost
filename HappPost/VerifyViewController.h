//
//  VerifyViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 10/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController<DataSyncManagerDelegate> {
    RegisterRequestObject* registerObj;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;

- (IBAction)registerButtonTapped:(id)sender;

@end
