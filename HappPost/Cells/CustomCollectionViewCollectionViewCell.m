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
#import "UIImageView+WebCache.h"

#import "DBManager.h"

NSString *const kCustomCellIdentifier = @"CustomCell";

@implementation CustomCollectionViewCollectionViewCell {
    __weak IBOutlet UIImageView *_photoImageView;
    __weak IBOutlet UILabel *_subheading;
    __weak IBOutlet UILabel *_heading;
    __weak IBOutlet UILabel *_authorName;
    __weak IBOutlet UILabel *_summary;
    __weak IBOutlet UILabel *_dateTime;
}

@synthesize delegate;

#pragma mark - Dynamic Properties

- (void)setCardModel:(CardModal *)cardModel {
    
    
    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBookmarkTapForNewsId:)];
    gesture.numberOfTouchesRequired = 1;
    [_heading addGestureRecognizer:gesture];
    [_heading setUserInteractionEnabled:YES];
    
    _cardModel = cardModel;
    
    _heading.text = cardModel.heading;
    _subheading.text = cardModel.subheading;
    _summary.text = cardModel.summary;
    _authorName.text = cardModel.author;
    _dateTime.text = cardModel.dateTime;
    
    newsId = cardModel.newsId;

    
    if (cardModel.headlineColor) {
        
        [_heading setTextColor:[self colorFromHexString:cardModel.headlineColor]];
        
    }
    else {
        [_heading setTextColor:[self.contentContainerView backgroundColor]];
    }
    

    if (![[DBManager sharedManager] isNewsIdBookmarked:newsId]) {
        
        [_subheading setTextColor:[UIColor blackColor]];
        
    }
    else {
        
        [_subheading setTextColor:[UIColor redColor]];
        
    }
    
    
    [self downloadNewsImagewithURL:cardModel.imgURL];
    
    
    
    //[_photoImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.imgURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
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
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
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

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (void) handleBookmarkTapForNewsId:(UILongPressGestureRecognizer *)gesture {
    
    
    if(UIGestureRecognizerStateBegan == gesture.state) {
        // Called on start of gesture, do work here
        
        if ([[DBManager sharedManager] isNewsIdBookmarked:newsId]) {
            
            [_subheading setTextColor:[UIColor blackColor]];
            [[DBManager sharedManager] deleteBookmarksWithNewsId:newsId];
            
            [delegate bookmarkRemoved];
            
        }
        else {
            
            if ([[[DBManager sharedManager] getAllNewsWithBookmarks] count] >= 25) {
                
                [delegate bookmarkLimitReached];
                
            }
            else {
                
                [_subheading setTextColor:[UIColor redColor]];
                [[DBManager sharedManager] insertEntryIntoBookmarksWithNewsId:newsId];
                
                [delegate bookmarkAdded];
                
            }
            
        }
        
    }
    
    if(UIGestureRecognizerStateChanged == gesture.state) {
        // Do repeated work here (repeats continuously) while finger is down
    }
    
    if(UIGestureRecognizerStateEnded == gesture.state) {
        // Do end work here when finger is lifted
    }
    
    
}

@end
