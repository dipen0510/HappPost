//
//  UserCommenstsTableViewCell.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 06/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTopLeftLabel.h"

@interface UserCommenstsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentDateLbl;
@property (weak, nonatomic) IBOutlet HPTopLeftLabel *commentDescriptonLbl;

@end
