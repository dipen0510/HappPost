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
#import "CardModal.h"
#import "UIImageView+AFNetworking.h"

NSString *const kCustomCellIdentifier = @"CustomCell";

@implementation CustomCollectionViewCollectionViewCell {
    __weak IBOutlet UIImageView *_photoImageView;
    __weak IBOutlet UILabel *_subheading;
    __weak IBOutlet UILabel *_heading;
    __weak IBOutlet UILabel *_authorName;
    __weak IBOutlet UILabel *_summary;
    __weak IBOutlet UILabel *_dateTime;
}

#pragma mark - Dynamic Properties

- (void)setCardModel:(CardModal *)cardModel {
    
    _cardModel = cardModel;
    
    _heading.text = cardModel.heading;
    _subheading.text = cardModel.subheading;
    _summary.text = cardModel.summary;
    _authorName.text = cardModel.author;
    _dateTime.text = cardModel.dateTime;
    
    [self downloadNewsImagewithURL:cardModel.imgURL];
    
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

-(void) downloadNewsImagewithURL:(NSString *)imgURL {
    
   if(![imgURL isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:imgURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UIImageView *weakImgView = _photoImageView;
        
        [_photoImageView setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  
                                                  weakImgView.image = image;
                                                  [weakImgView setNeedsLayout];
                                                  
                                              } failure:nil];
        
    }
}

@end
