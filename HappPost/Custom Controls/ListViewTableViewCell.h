//
//  ListViewTableViewCell.h
//  
//
//  Created by Dipen Sekhsaria on 18/11/15.
//
//

#import <UIKit/UIKit.h>

@interface ListViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImgView;
@property (weak, nonatomic) IBOutlet UILabel *newsHeading;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@property (weak, nonatomic) IBOutlet UILabel *newsTime;
@property (weak, nonatomic) IBOutlet UIView *newsView;
@property (weak, nonatomic) IBOutlet UIImageView *borderImgView;
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end
