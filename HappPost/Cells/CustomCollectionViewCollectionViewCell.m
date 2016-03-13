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
#import "SmileyRequestObject.h"

NSString *const kCustomCellIdentifier = @"CustomCell";

@implementation CustomCollectionViewCollectionViewCell {
    __weak IBOutlet UIImageView *_photoImageView;
    __weak IBOutlet UILabel *_subheading;
    __weak IBOutlet UILabel *_heading;
    __weak IBOutlet UILabel *_authorName;
    __weak IBOutlet UILabel *_dateTime;
    __weak IBOutlet UITextView *summary;
}

@synthesize delegate;

#pragma mark - Dynamic Properties

- (void)setCardModel:(CardModal *)cardModel {
    
    _adImageView.hidden = YES;
    _cardView.hidden = NO;
    
    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBookmarkTapForNewsId:)];
    gesture.numberOfTouchesRequired = 1;
    [_heading addGestureRecognizer:gesture];
    [_heading setUserInteractionEnabled:YES];
    
    self.playerView.layer.zPosition = 1;
    _heading.layer.zPosition = 20;
    self.headingBGView.layer.zPosition = 20;
    _cardModel = cardModel;
    
    _heading.text = cardModel.heading;
    _subheading.text = cardModel.subheading;
    summary.text = cardModel.summary;
    _authorName.text = cardModel.author;
    _dateTime.text = cardModel.dateTime;
    
    CGSize size = [_heading sizeOfMultiLineLabel];
    if (size.height < 50) {
        self.headingBGViewHeightConstraint.constant = 40.0;
        self.headingHeightConstraint.constant = 40.0;
    }
    else {
        self.headingBGViewHeightConstraint.constant = 59.0;
        self.headingHeightConstraint.constant = 59.0;
    }
    
    newsId = cardModel.newsId;

    [summary setContentOffset:CGPointZero animated:YES];
    
    if (cardModel.headlineColor) {
        
        [_heading setTextColor:[self colorFromHexString:cardModel.headlineColor]];
        
    }
    else {
        [_heading setTextColor:[self.contentContainerView backgroundColor]];
    }
    

    if (![[DBManager sharedManager] isNewsIdBookmarked:newsId]) {
        
        [_heading setTextColor:[self.contentContainerView backgroundColor]];
        
    }
    else {
        
        [_heading setTextColor:[UIColor whiteColor]];
        
    }
    
    
    if ([[DBManager sharedManager] isNewsIdSmiled:newsId]) {
        
        [self.smileyButton setImage:[UIImage imageNamed:@"smily-2.png"] forState:UIControlStateNormal];
        
    }
    else {
        
        [self.smileyButton setImage:[UIImage imageNamed:@"smiling.png"] forState:UIControlStateNormal];
        
    }
    
    
    
    if ([self isVideoURL:cardModel.imgURL]) {
        
        NSString* videoURl = [[cardModel.imgURL componentsSeparatedByString:@"/"] lastObject];
        if ([videoURl containsString:@"watch"]) {
            
            videoURl = [[videoURl componentsSeparatedByString:@"="] lastObject];
            
        }
        
        [self.playerView setBackgroundColor:[UIColor blackColor]];
        [self.playerView loadWithVideoId:videoURl];
        [self.playerView setDelegate:self];
        [self.playerView setHidden:NO];
        [self.playerView addGestureRecognizer:gesture];
        
        [_photoImageView setHidden:YES];
        [_heading setHidden:NO];
        [self.headingBGView setHidden:NO];
        
        
    }
    else {
        [_photoImageView setHidden:NO];
        [_heading setHidden:NO];
        [self.headingBGView setHidden:NO];
        [self.playerView setHidden:YES];
        [self.playerView stopVideo];
        [self.playerView clearVideo];
        [self.playerView removeWebView];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self downloadNewsImagewithURL:cardModel.imgURL];
    }
    
    
    
    
    
    
    //[_photoImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.imgURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:_photoImageView.bounds
//                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(15.0, 15.0)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _photoImageView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _photoImageView.layer.mask = maskLayer;
//    
//    UIBezierPath *maskPath1;
//    maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.contentContainerView.bounds
//                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
//                                           cornerRadii:CGSizeMake(15.0, 15.0)];
//    
//    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
//    maskLayer1.frame = self.contentContainerView.bounds;
//    maskLayer1.path = maskPath1.CGPath;
//    self.contentContainerView.layer.mask = maskLayer1;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
}



- (void)setAdModel:(AdModal *)adModel {
    
    _adImageView.hidden = NO;
    _cardView.hidden = YES;
    
    _adModel = adModel;
    
    if(![_adModel.adImage isEqualToString:@""])
    {
        NSString* urlTextEscaped = [_adModel.adImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlTextEscaped];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UIImageView *weakImgView = _adImageView;
        
        [_adImageView setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            
                                            weakImgView.image = image;
                                            [weakImgView setNeedsLayout];
                                            
                                        } failure:nil];
        
    }
    
}

-(void) downloadNewsImagewithURL:(NSString *)imgURL {
    
   if(![imgURL isEqualToString:@""])
    {
        NSString* urlTextEscaped = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlTextEscaped];
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
            
            [_heading setTextColor:[self.contentContainerView backgroundColor]];
            [[DBManager sharedManager] deleteBookmarksWithNewsId:newsId];
            
            [delegate bookmarkRemoved];
            
        }
        else {
            
            if ([[[DBManager sharedManager] getAllNewsWithBookmarks] count] >= 25) {
                
                [delegate bookmarkLimitReached];
                
            }
            else {
                
                [_heading setTextColor:[UIColor whiteColor]];
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

- (IBAction)smileyButtonTapped:(id)sender {
    
    if (![[DBManager sharedManager] isNewsIdSmiled:newsId]) {
        
        [self.smileyButton setImage:[UIImage imageNamed:@"smily-2.png"] forState:UIControlStateNormal];
        [self startMarkSmileService];
        [[DBManager sharedManager] insertEntryIntoSmileyWithNewsId:newsId];

        
    }
    else {
        
        [self.smileyButton setImage:[UIImage imageNamed:@"smiling.png"] forState:UIControlStateNormal];
        [self startMarkUnsmileService];
        [[DBManager sharedManager] deleteSmileyWithNewsId:newsId];
        
    }
    
    
}

#pragma mark - API Handling

-(void) startMarkSmileService {

    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kMarkSmile;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForSmile]];
    
}

-(void) startMarkUnsmileService {
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kMarkUnSmile;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForSmile]];
    
}


- (BOOL) isVideoURL:(NSString *)url {
    
    if ([url containsString:@"youtu"]) {
        return true;
    }
    return false;
    
}

#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForSmile {
    
    SmileyRequestObject* requestObj = [[SmileyRequestObject alloc] init];
    requestObj.userId = [[SharedClass sharedInstance] userId];
    requestObj.newsId = newsId;
    
    return [requestObj createRequestDictionary];
    
}


#pragma mark - Youtube Player Delegates

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
//    
//    [self.playerView stopVideo];
//    [self.playerView clearVideo];
    
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{}
- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality{}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{}


@end
