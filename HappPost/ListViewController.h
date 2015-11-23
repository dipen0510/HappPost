//
//  ListViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 17/11/15.
//  Copyright (c) 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTblView;
- (IBAction)switchViewButtonTapped:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

@end

