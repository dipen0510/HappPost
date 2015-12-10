//
//  CardContentViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 22/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCollectionViewCell.h"

@interface CardContentViewController : GAITrackedViewController <CustomCollectionViewCollectionViewCellDelegate,DataSyncManagerDelegate,UISearchBarDelegate> {
    BOOL isNavigationViewShown;
    NSMutableArray* newsArr;
    long selectedIndex;
    BOOL isRefreshButtonTapped;
    NSString* searchText;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationMenuHeightConstraint;
- (IBAction)expandButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)refreshButtonTapped:(id)sender;

@end
