//
//  ContentDetailViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 25/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfographicsObject.h"

@interface ContentDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate> {
    
    NewsInfographicsObject* secondaryImageNewsInfogrphicsObj;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *primaryImageView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondaryImageView;
@property (weak, nonatomic) IBOutlet UILabel *primaryDescriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *secondaryDescriptionLabel;

@property (strong, nonatomic) SingleNewsObject* newsObj;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subheadingHeightCoonstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primaryDescriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scondaryDescriptionHeadingConstraint;

- (IBAction)menuButtonTapped:(id)sender;
@end
