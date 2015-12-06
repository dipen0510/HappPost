//
//  CardContentViewController.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 22/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardContentViewController : UIViewController {
    BOOL isNavigationViewShown;
    NSMutableArray* newsArr;
    long selectedIndex;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationMenuHeightConstraint;
- (IBAction)expandButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

@end
