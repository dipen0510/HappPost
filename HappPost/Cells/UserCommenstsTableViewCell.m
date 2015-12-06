//
//  UserCommenstsTableViewCell.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 06/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "UserCommenstsTableViewCell.h"

@implementation UserCommenstsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
