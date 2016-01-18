//
//  MenuView.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 24/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "MenuView.h"
#import "MenuTableViewCell.h"
#import "MasterGenreObject.h"

@implementation MenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    //[self.mewnuScrollView setContentSize:CGSizeMake(300, 1200)];
    NSLog(@"delegate:%@ dataSource:%@", self.genreTableView.delegate, self.genreTableView.dataSource);
    
    
    self.mewnuScrollView.delegate = self;
    [self.mewnuScrollView setShowsHorizontalScrollIndicator:NO];
    
    selectedGenreArr = [[NSMutableArray alloc] initWithArray:[[SharedClass sharedInstance] selectedGenresArr]];
    selectedMyNewsArr = [[NSMutableArray alloc] initWithArray:[[SharedClass sharedInstance] selectedMyNewsArr]];
    
    masterGenreArr = [[NSMutableArray alloc] init];
    masterGenreArr = [[DBManager sharedManager] getAllMasterGenres];
    
    _myNewsCollapsedSections = [NSMutableSet new];
    _genresCollapsedSections = [NSMutableSet new];
    _notificationsCollapsedSections = [NSMutableSet new];
    _finePrintCollapsedSections = [NSMutableSet new];
    
    [_genresCollapsedSections addObject:@(0)];
    [_myNewsCollapsedSections addObject:@(0)];
    [_notificationsCollapsedSections addObject:@(0)];
    [_finePrintCollapsedSections addObject:@(0)];
    
    self.menuTableViewHeightConstraint.constant = 55.;
    self.genreTableViewHeightConstraint.constant = 55.;
     self.notificationsTableViewHeightConstraint.constant = 55.;
     self.finePrintTableViewHeightConstraint.constant = 55.;
    
    [self.menuTableView setBackgroundColor:[UIColor clearColor]];
    
    settingsDict = [[NSMutableDictionary alloc] init];
    settingsDict = [[DBManager sharedManager] getAllSettings] ;
    selectedNotificationIndex = [[settingsDict valueForKey:notificationSettingKey] intValue] - 1;
    
    
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    tapGesture.delegate = self;
//    [self addGestureRecognizer:tapGesture];
    

    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}



#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.genreTableView) {
        return [_genresCollapsedSections containsObject:@(section)] ? 0 : masterGenreArr.count;
    }
    if (tableView == self.notificationsTableView) {
        return [_notificationsCollapsedSections containsObject:@(section)] ? 0 : 3;
    }
    if (tableView == self.finePrintTableView) {
        return [_finePrintCollapsedSections containsObject:@(section)] ? 0 : 2;
    }
    
    return [_myNewsCollapsedSections containsObject:@(section)] ? 0 : masterGenreArr.count;

}

- (void) myNewsSectionTapped:(UIButton*)sender {
    
    if ([[[SharedClass sharedInstance] selectedMyNewsArr] count] > 0) {
        [self.delegate myNewsSectionSelected];
    }
    else {
        [self sectionButtonTouchUpInside:sender];
    }
    
    
}

-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows {
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

-(void)sectionButtonTouchUpInside:(UIButton*)sender {
    
    if (sender.tag == 0) {
        [self.menuTableView beginUpdates];
        int section = 0;
        bool shouldCollapse = ![_myNewsCollapsedSections containsObject:@(section)];
        if (shouldCollapse) {
            int numOfRows = (int)[self.menuTableView numberOfRowsInSection:section];
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.menuTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.menuTableViewHeightConstraint.constant = 55.;
            [_myNewsCollapsedSections addObject:@(section)];
        }
        else {
            int numOfRows = masterGenreArr.count;
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.menuTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.menuTableViewHeightConstraint.constant = 240;
            [_myNewsCollapsedSections removeObject:@(section)];
        }
        [self.menuTableView endUpdates];
        
        
        
        [self.genreTableView beginUpdates];
            int numOfRows = (int)[self.genreTableView numberOfRowsInSection:section];
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.genreTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.genreTableViewHeightConstraint.constant = 55.;
            [_genresCollapsedSections addObject:@(section)];
        [self.genreTableView endUpdates];
        
        [self.notificationsTableView beginUpdates];
        numOfRows = (int)[self.notificationsTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.notificationsTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.notificationsTableViewHeightConstraint.constant = 55.;
        [_notificationsCollapsedSections addObject:@(section)];
        [self.notificationsTableView endUpdates];
        
        [self.finePrintTableView beginUpdates];
        numOfRows = (int)[self.finePrintTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.finePrintTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.finePrintTableViewHeightConstraint.constant = 55.;
        [_finePrintCollapsedSections addObject:@(section)];
        [self.finePrintTableView endUpdates];
        
        
        
    }
    
    if (sender.tag == 1) {
        [self.genreTableView beginUpdates];
        int section = 0;
        bool shouldCollapse = ![_genresCollapsedSections containsObject:@(section)];
        if (shouldCollapse) {
            int numOfRows = (int)[self.genreTableView numberOfRowsInSection:section];
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.genreTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.genreTableViewHeightConstraint.constant = 55.;
            [_genresCollapsedSections addObject:@(section)];
        }
        else {
            int numOfRows = masterGenreArr.count;
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.genreTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.genreTableViewHeightConstraint.constant = 240;
            [_genresCollapsedSections removeObject:@(section)];
        }
        [self.genreTableView endUpdates];
        
        
        [self.menuTableView beginUpdates];
        int numOfRows = (int)[self.menuTableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.menuTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.menuTableViewHeightConstraint.constant = 55.;
        [_myNewsCollapsedSections addObject:@(section)];
        [self.menuTableView endUpdates];
        
        [self.notificationsTableView beginUpdates];
        numOfRows = (int)[self.notificationsTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.notificationsTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.notificationsTableViewHeightConstraint.constant = 55.;
        [_notificationsCollapsedSections addObject:@(section)];
        [self.notificationsTableView endUpdates];
        
        [self.finePrintTableView beginUpdates];
        numOfRows = (int)[self.finePrintTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.finePrintTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.finePrintTableViewHeightConstraint.constant = 55.;
        [_finePrintCollapsedSections addObject:@(section)];
        [self.finePrintTableView endUpdates];
        
        
    }
    
    if (sender.tag == 2) {
        [self.notificationsTableView beginUpdates];
        int section = 0;
        bool shouldCollapse = ![_notificationsCollapsedSections containsObject:@(section)];
        if (shouldCollapse) {
            int numOfRows = (int)[self.notificationsTableView numberOfRowsInSection:section];
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.notificationsTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.notificationsTableViewHeightConstraint.constant = 55.;
            [_notificationsCollapsedSections addObject:@(section)];
        }
        else {
            int numOfRows = 3;
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.notificationsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.notificationsTableViewHeightConstraint.constant = 200;
            [_notificationsCollapsedSections removeObject:@(section)];
        }
        [self.notificationsTableView endUpdates];
        
        [self.menuTableView beginUpdates];
        int numOfRows = (int)[self.menuTableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.menuTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.menuTableViewHeightConstraint.constant = 55.;
        [_myNewsCollapsedSections addObject:@(section)];
        [self.menuTableView endUpdates];
        
        [self.genreTableView beginUpdates];
        numOfRows = (int)[self.genreTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.genreTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.genreTableViewHeightConstraint.constant = 55.;
        [_genresCollapsedSections addObject:@(section)];
        [self.genreTableView endUpdates];
        
        [self.finePrintTableView beginUpdates];
        numOfRows = (int)[self.finePrintTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.finePrintTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.finePrintTableViewHeightConstraint.constant = 55.;
        [_finePrintCollapsedSections addObject:@(section)];
        [self.finePrintTableView endUpdates];
        
    }
    
    if (sender.tag == 3) {
        [self.finePrintTableView beginUpdates];
        int section = 0;
        bool shouldCollapse = ![_finePrintCollapsedSections containsObject:@(section)];
        if (shouldCollapse) {
            int numOfRows = (int)[self.finePrintTableView numberOfRowsInSection:section];
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.finePrintTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.finePrintTableViewHeightConstraint.constant = 55.;
            [_finePrintCollapsedSections addObject:@(section)];
        }
        else {
            int numOfRows = 2;
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            [self.finePrintTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            self.finePrintTableViewHeightConstraint.constant = 150;
            [_finePrintCollapsedSections removeObject:@(section)];
        }
        [self.finePrintTableView endUpdates];
        
        [self.menuTableView beginUpdates];
        int numOfRows = (int)[self.menuTableView numberOfRowsInSection:section];
        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.menuTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.menuTableViewHeightConstraint.constant = 55.;
        [_myNewsCollapsedSections addObject:@(section)];
        [self.menuTableView endUpdates];
        
        [self.notificationsTableView beginUpdates];
        numOfRows = (int)[self.notificationsTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.notificationsTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.notificationsTableViewHeightConstraint.constant = 55.;
        [_notificationsCollapsedSections addObject:@(section)];
        [self.notificationsTableView endUpdates];
        
        [self.genreTableView beginUpdates];
        numOfRows = (int)[self.genreTableView numberOfRowsInSection:section];
        indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
        [self.genreTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        self.genreTableViewHeightConstraint.constant = 55.;
        [_genresCollapsedSections addObject:@(section)];
        [self.genreTableView endUpdates];
        
        
    }
    
    //[_tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    NSString* identifier = @"MenuView";
    MenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    
    cell.categoryImageWidthConstraint.constant = 25;
    
    
    
    if (tableView == self.genreTableView) {
        
        MasterGenreObject* genreObj = (MasterGenreObject *)[masterGenreArr objectAtIndex:indexPath.row];
        
        if ([selectedGenreArr containsObject:genreObj.genreId]) {
            cell.backgroundColor = [UIColor colorWithRed:251./255 green:193./255 blue:21./255 alpha:0.8];
        }
        else {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.categoryLabel.text = genreObj.name;
        NSString *imgURL = [NSString stringWithFormat:@"%@/%@.png",HappPostGenreImageURL,[self genreImageNameWithoutSpecial:genreObj.name]];
        
        if(![imgURL isEqualToString:@""])
        {
            NSString* urlTextEscaped = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlTextEscaped];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@""];
            
            __weak UIImageView *weakImgView = cell.categoryImage;
            
            [cell.categoryImage setImageWithURLRequest:request
                                    placeholderImage:placeholderImage
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 
                                                 weakImgView.image = image;
                                                 [weakImgView setNeedsLayout];
                                                 
                                             } failure:nil];
            
        }
        
    }
    else if (tableView == self.menuTableView){
        
        MasterGenreObject* genreObj = (MasterGenreObject *)[masterGenreArr objectAtIndex:indexPath.row];
        
        if ([selectedMyNewsArr containsObject:genreObj.genreId]) {
            cell.backgroundColor = [UIColor colorWithRed:251./255 green:193./255 blue:21./255 alpha:0.8];
        }
        else {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        
        
        cell.categoryLabel.text = genreObj.name;
        NSString *imgURL = [NSString stringWithFormat:@"%@/%@.png",HappPostGenreImageURL,[self genreImageNameWithoutSpecial:genreObj.name]];
        
        if(![imgURL isEqualToString:@""])
        {
            NSString* urlTextEscaped = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlTextEscaped];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@""];
            
            __weak UIImageView *weakImgView = cell.categoryImage;
            
            [cell.categoryImage setImageWithURLRequest:request
                                      placeholderImage:placeholderImage
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   
                                                   weakImgView.image = image;
                                                   [weakImgView setNeedsLayout];
                                                   
                                               } failure:nil];
            
        }
        
    }
    else {
        
        cell.backgroundColor = [UIColor clearColor];
        
        if (tableView == self.notificationsTableView) {
            
            if (indexPath.row == selectedNotificationIndex) {
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"radio_fill"]];
            }
            else {
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"radio"]];
            }
            
            
            if (indexPath.row == 0) {
                cell.categoryLabel.text = @"None";
            }
            else if (indexPath.row == 1) {
                cell.categoryLabel.text = @"2-3 Notifications / Day";
            }
            else {
                cell.categoryLabel.text = @"All Notifications";
            }
            
        }
        else {
            
            cell.categoryImageWidthConstraint.constant = 0;
            
            if (indexPath.row == 0) {
                cell.categoryLabel.text = @"About Us";
            }
            else {
                cell.categoryLabel.text = @"Privacy Policy";
            }
            
        }
        
    }
    
    
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-20, 0, tableView.frame.size.width, 55)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 17.5, tableView.frame.size.width, 20)];
    [label setFont:[UIFont boldSystemFontOfSize:17.0]];
    [label setTextColor:[UIColor whiteColor]];
    
    NSString *string = @"";
    
    UIButton* dropButton = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 35.0, 17.5, 25.0, 25.0)];
    [dropButton addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [dropButton setImage:[UIImage imageNamed:@"menuDropArrow"] forState:UIControlStateNormal];
    
    UIButton* myNewsRightButton = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 70.0, 17.5, 25.0, 25.0)];
    //[myNewsRightButton setImage:[UIImage imageNamed:@"menuArrow"] forState:UIControlStateNormal];
    
    UIButton* result = [[UIButton alloc] initWithFrame:view.frame];
    
    [result addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (tableView == self.genreTableView) {
        string = @"Genres";
        result.tag = 1;
        dropButton.tag = 1;
    }
    else if (tableView == self.menuTableView) {
        string = @"My News";
        result.tag = 0;
        dropButton.tag = 0;
        [view addSubview:myNewsRightButton];
        [result removeTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [result addTarget:self action:@selector(myNewsSectionTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (tableView == self.notificationsTableView) {
        string = @"My Notifications";
        result.tag = 2;
        dropButton.tag = 2;
    }
    else {
        string = @"Fine Print";
        result.tag = 3;
        dropButton.tag = 3;
    }
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view addSubview:result];
    [view addSubview:dropButton];
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 55.;
    
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (tableView == self.notificationsTableView || tableView == self.finePrintTableView) {
        
        if (tableView == self.finePrintTableView) {
            
            if (indexPath.row == 0) {
                [self.delegate aboutUsTapped];
            }
            else {
                [self.delegate privacyPolicyTapped];
            }
            
        }
        else {
            
            selectedNotificationIndex = indexPath.row;
            [self.notificationsTableView reloadData];
            [[DBManager sharedManager] insertEntryIntoSettingsTableWithTimeStamp:[settingsDict valueForKey:timestampKey] andNotificationSetting:[NSString stringWithFormat:@"%ld",(selectedNotificationIndex+1)]];
            
        }
        
        
    }
    else {
        
        MasterGenreObject* genreObj = (MasterGenreObject *)[masterGenreArr objectAtIndex:indexPath.row];
        
        if (tableView == self.genreTableView) {
            
            if ([selectedGenreArr containsObject:genreObj.genreId]) {
                [selectedGenreArr removeObject:genreObj.genreId];
            }
            else {
                [selectedGenreArr removeAllObjects];
                [selectedMyNewsArr removeAllObjects];
                [selectedGenreArr addObject:genreObj.genreId];
            }
            
        }
        else if (tableView == self.menuTableView){
            
            if ([selectedMyNewsArr containsObject:genreObj.genreId]) {
                [selectedMyNewsArr removeObject:genreObj.genreId];
            }
            else {
                [selectedGenreArr removeAllObjects];
                [selectedMyNewsArr addObject:genreObj.genreId];
            }
            
        }
        
        [[SharedClass sharedInstance] setSelectedGenresArr:selectedGenreArr];
        [[SharedClass sharedInstance] setSelectedMyNewsArr:selectedMyNewsArr];
        
        
        [[SharedClass sharedInstance] setMenuOptionType:2];
        
        [self.genreTableView reloadData];
        [self.menuTableView reloadData];
        
        
        if (tableView == self.genreTableView) {
            [self.delegate genreCellSelected];
        }
        
        
    }
    
    
}


- (NSString *) genreImageNameWithoutSpecial:(NSString *)imageName {
    
    NSString* str = imageName;
    
    if ([str containsString:@" & "]) {
        str = [str stringByReplacingOccurrencesOfString:@" & " withString:@""];
    }
    if ([str containsString:@"/"]) {
        str = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}


- (void) hideKeyboard {
    
    [self endEditing:YES];
    
}



@end
