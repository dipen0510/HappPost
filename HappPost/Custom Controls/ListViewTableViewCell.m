//
//  ListViewTableViewCell.m
//  
//
//  Created by Dipen Sekhsaria on 18/11/15.
//
//

#import "ListViewTableViewCell.h"

@implementation ListViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.newsView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.newsView.layer.borderWidth = 1.0;
    self.newsView.layer.cornerRadius = 10.0;
    self.newsImgView.layer.cornerRadius = 10.0;
    self.newsImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
