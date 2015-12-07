//
//  ListViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 17/11/15.
//  Copyright (c) 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsContentRequestObject.h"

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,DataSyncManagerDelegate> {
    
    NSMutableArray* newsContentArr;
    long selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *listTblView;
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)refreshButtonTapped:(id)sender;

@end

