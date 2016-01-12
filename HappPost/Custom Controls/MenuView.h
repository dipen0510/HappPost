//
//  MenuView.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 24/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate <NSObject>

@optional

- (void) genreCellSelected;
- (void) myNewsSectionSelected;
- (void) aboutUsTapped;
- (void) privacyPolicyTapped;

@end


@interface MenuView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    
     NSMutableSet* _myNewsCollapsedSections;
    NSMutableSet* _genresCollapsedSections;
    NSMutableArray* selectedGenreArr;
    NSMutableArray* selectedMyNewsArr;
    
    NSMutableArray* masterGenreArr;
    
    NSMutableSet* _notificationsCollapsedSections;
    NSMutableSet* _finePrintCollapsedSections;
    
    NSMutableDictionary* settingsDict;
    
    long selectedNotificationIndex;
    
}

@property (nonatomic,assign)  id <MenuViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genreTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationsTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finePrintTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *mewnuScrollView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *genreTableView;
@property (weak, nonatomic) IBOutlet UIButton *switchToCardView;
@property (weak, nonatomic) IBOutlet UIButton *noneButton;
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *allNotificationButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareHappPostButton;
@property (weak, nonatomic) IBOutlet UIButton *myBookbarkButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;
@property (weak, nonatomic) IBOutlet UITableView *finePrintTableView;

@end
