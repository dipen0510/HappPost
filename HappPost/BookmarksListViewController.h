//
//  BookmarksListViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 08/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarksListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray* newsContentArr;
    long selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *listTblView;
- (IBAction)menuButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *emptyBookmarksLabel;


@end
