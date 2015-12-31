//
//  ContentDetailViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 25/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfographicsObject.h"

@interface ContentDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,YTPlayerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,DataSyncManagerDelegate,UIDocumentInteractionControllerDelegate> {
    
    NewsInfographicsObject* secondaryImageNewsInfogrphicsObj;
    NSMutableArray* commentArr;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *primaryImageView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondaryImageView;
@property (weak, nonatomic) IBOutlet UILabel *primaryDescriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *secondaryDescriptionLabel;
@property (weak, nonatomic) IBOutlet YTPlayerView *videoPlayerView;
@property (weak, nonatomic) IBOutlet YTPlayerView *primaryVideoPlayerView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *authorBioLabel;

@property (strong, nonatomic) SingleNewsObject* newsObj;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subheadingHeightCoonstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primaryDescriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scondaryDescriptionHeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *authorBioHeightConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primaryDescriptionTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
@end
