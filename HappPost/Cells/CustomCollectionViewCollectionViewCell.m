//
//  CustomCollectionViewCollectionViewCell.m
//  CoverFlowLayoutDemo
//
//  Created by Yuriy Romanchenko on 3/13/15.
//  Copyright (c) 2015 solomidSF. All rights reserved.
//

// Cell
#import "CustomCollectionViewCollectionViewCell.h"

// Model
#import "PhotoModel.h"

NSString *const kCustomCellIdentifier = @"CustomCell";

@implementation CustomCollectionViewCollectionViewCell {
    __weak IBOutlet UIImageView *_photoImageView;
    __weak IBOutlet UILabel *_photoDescription;
}

#pragma mark - Dynamic Properties

- (void)setPhotoModel:(PhotoModel *)photoModel {
    
    _photoModel = photoModel;
    
    _photoImageView.image = photoModel.image;
    _photoDescription.text = photoModel.imageDescription;
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_photoImageView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(15.0, 15.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _photoImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    _photoImageView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath1;
    maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.contentContainerView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(15.0, 15.0)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.contentContainerView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.contentContainerView.layer.mask = maskLayer1;
}

@end
