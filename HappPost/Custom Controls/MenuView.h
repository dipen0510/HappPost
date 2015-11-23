//
//  MenuView.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 24/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIButton *switchToCardView;
@property (weak, nonatomic) IBOutlet UIButton *noneButton;
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *allNotificationButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
