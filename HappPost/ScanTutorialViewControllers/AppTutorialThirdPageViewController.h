//
//  AppTutorialThirdPageViewController.h
//  Happ Post
//
//  Created by Dipen Sekhsaria on 30/10/15.
//  Copyright © 2015 Stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppTutorialThirdPageViewControllerDelegate <NSObject>

-(void) didTapDoneButton;

@end

@interface AppTutorialThirdPageViewController : UIViewController

@property NSUInteger pageIndex;
@property (nonatomic,assign)  id <AppTutorialThirdPageViewControllerDelegate> delegate;

- (IBAction)doneButtonTapped:(id)sender;

@end
