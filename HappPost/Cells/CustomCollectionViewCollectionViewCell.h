//
//  CustomCollectionViewCollectionViewCell.h
//  CoverFlowLayoutDemo
//
//  Created by Yuriy Romanchenko on 3/13/15.
//  Copyright (c) 2015 solomidSF. All rights reserved.
//

@import UIKit;

extern NSString *const kCustomCellIdentifier;

@class CardModal;


@protocol CustomCollectionViewCollectionViewCellDelegate <NSObject>

-(void) bookmarkAdded;
-(void) bookmarkRemoved;
-(void) bookmarkLimitReached;

@end



/**
 *  Custom collection view cell that shows simple photo.
 */
@interface CustomCollectionViewCollectionViewCell : UICollectionViewCell<YTPlayerViewDelegate> {
    
    NSString* newsId;
}

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (nonatomic,assign)  id <CustomCollectionViewCollectionViewCellDelegate> delegate;
@property (nonatomic) CardModal *cardModel;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIView *headingBGView;
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headingBGViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headingHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *smileyButton;
- (IBAction)smileyButtonTapped:(id)sender;

@property (nonatomic) AdModal *adModel;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@end
