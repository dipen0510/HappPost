//
//  CardContentViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 22/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCollectionViewCell.h"
#import "MenuView.h"

@interface CardContentViewController : UIViewController <CustomCollectionViewCollectionViewCellDelegate,DataSyncManagerDelegate,UISearchBarDelegate,MenuViewDelegate> {
    BOOL isNavigationViewShown;
    NSMutableArray* newsArr;
    long selectedIndex;
    BOOL isRefreshButtonTapped;
    int webViewSegueType;
}
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet UILabel *menuTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationMenuHeightConstraint;
- (IBAction)expandButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)refreshButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonLeftConstraint;

@end
