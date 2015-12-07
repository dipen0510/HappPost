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
@interface CustomCollectionViewCollectionViewCell : UICollectionViewCell {
    
    NSString* newsId;
    
}

@property (nonatomic,assign)  id <CustomCollectionViewCollectionViewCellDelegate> delegate;
@property (nonatomic) CardModal *cardModel;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@end
