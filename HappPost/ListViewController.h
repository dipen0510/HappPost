//
//  ListViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 17/11/15.
//  Copyright (c) 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "NewsContentRequestObject.h"

@interface ListViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate,DataSyncManagerDelegate,UISearchBarDelegate,YTPlayerViewDelegate,MenuViewDelegate> {
    
    NSMutableArray* newsContentArr;
    long selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *listTblView;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)refreshButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonLeftConstraint;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@end

