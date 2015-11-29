//
//  RegisterViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterRequestObject.h"
#import "RegisterResponseObject.h"

@interface RegisterViewController : UIViewController<DataSyncManagerDelegate> {
    RegisterRequestObject* registerObj;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;

- (IBAction)registerButtonTapped:(id)sender;
- (IBAction)skipForNowButtonTapped:(id)sender;

@end
