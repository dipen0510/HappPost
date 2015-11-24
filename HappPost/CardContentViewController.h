//
//  CardContentViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 22/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardContentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    BOOL isNavigationViewShown;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationMenuHeightConstraint;
- (IBAction)switcchToCardContentButtonTapped:(id)sender;
- (IBAction)expandButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

@end
