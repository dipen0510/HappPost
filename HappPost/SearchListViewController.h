//
//  SearchListViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 10/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray* newsContentArr;
    long selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *listTblView;
- (IBAction)menuButtonTapped:(id)sender;



@end
