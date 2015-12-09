//
//  SplashViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 29/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterRequestObject.h"

@interface SplashViewController : UIViewController<DataSyncManagerDelegate> {
    RegisterRequestObject* registerObj;
}

@end
