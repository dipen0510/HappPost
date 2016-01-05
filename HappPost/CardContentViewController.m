//
//  CardContentViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 22/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "CardContentViewController.h"

// Components
#import "YRCoverFlowLayout.h"

// Modal
#import "CardModal.h"

// Cells
#import "CustomCollectionViewCollectionViewCell.h"
#import "MenuView.h"

//Controllers
#import "ContentDetailViewController.h"
#import "NewsContentRequestObject.h"
#import "SearchListViewController.h"


@interface CardContentViewController ()
<
UICollectionViewDelegate,UICollectionViewDataSource
>{
    MenuView* menuView;
    UIVisualEffectView *blurEffectView;
}

@end

@implementation CardContentViewController {
    NSMutableArray *_photoModelsDatasource;
    
    __weak IBOutlet UICollectionView *_photosCollectionView;
    __weak IBOutlet UICollectionViewFlowLayout *_coverFlowLayout;
    
    __weak IBOutlet UILabel *_maxDegreeValueLabel;
    __weak IBOutlet UILabel *_coverDensityValueLabel;
    
    // To support all screen sizes we need to keep item size consistent.
    CGSize _originalItemSize;
    CGSize _originalCollectionViewSize;
    
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _originalItemSize = _coverFlowLayout.itemSize;
    _originalCollectionViewSize = _photosCollectionView.bounds.size;
    
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set screen name.
    
    [[GoogleAnalyticsHelper sharedInstance] sendScreenTrackingWithName:@"News Card Screen"];
        
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self generateDatasource];
    [self startGetNewsContentService];
}



#pragma mark - Auto Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // We should invalidate layout in case we are switching orientation.
    // If we won't do that we will receive warning from collection view's flow layout that cell size isn't correct.
    [_coverFlowLayout invalidateLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Now we should calculate new item size depending on new collection view size.
    _coverFlowLayout.itemSize = (CGSize){
        _photosCollectionView.bounds.size.width * _originalItemSize.width / _originalCollectionViewSize.width,
        _photosCollectionView.bounds.size.height * _originalItemSize.height / _originalCollectionViewSize.height
    };
    
    
    // Forcely tell collection view to reload current data.
    [_photosCollectionView setNeedsLayout];
    [_photosCollectionView layoutIfNeeded];
    [_photosCollectionView reloadData];
    
//    if (isRefreshButtonTapped) {
//        isRefreshButtonTapped = false;
//        [_photosCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
//                                      atScrollPosition:UICollectionViewScrollPositionTop
//                                              animated:YES];
//    }
}


- (void) setupMenuView {
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
    menuView = [subviewArray objectAtIndex:0];
    menuView.frame = self.view.frame;
    menuView.transform = CGAffineTransformScale(self.view.transform, 3, 3);
    menuView.alpha = 0.0;
    menuView.delegate = self;
    [menuView.closeButton addTarget:self action:@selector(hideMenuView) forControlEvents:UIControlEventTouchUpInside];
    [menuView.switchToCardView addTarget:self action:@selector(switchViewButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuView.myBookbarkButton addTarget:self action:@selector(bookmarkButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    menuView.searchBar.delegate = self;
    [menuView.switchToCardView setTitle:@"Switch To List View" forState:UIControlStateNormal];
    
}


#pragma mark - Private

- (void)generateDatasource {
    
    _photoModelsDatasource = [[NSMutableArray alloc] init];
    
    newsArr = [[NSMutableArray alloc] init];
    self.menuTitle.text = @"";
    
    if ([[SharedClass sharedInstance] menuOptionType] == 1) {
        
        self.backButtonLeftConstraint.constant = 8;
        [self.refreshButton setHidden:YES];
        newsArr = [[DBManager sharedManager] getAllNewsForSearchedText:[[SharedClass sharedInstance] searchText]];
        self.menuTitle.text = @"Search";
        
    }
    else if ([[SharedClass sharedInstance] menuOptionType] == 2) {
        
        self.backButtonLeftConstraint.constant = 8;
        [self.refreshButton setHidden:YES];
        newsArr = [[DBManager sharedManager] checkAndFetchNews];
        
        if ([[[SharedClass sharedInstance] selectedMyNewsArr] count] > 0) {
            self.menuTitle.text = @"My News";
        }
        if ([[[SharedClass sharedInstance] selectedGenresArr] count] > 0) {
            self.menuTitle.text = [[DBManager sharedManager] getNameFrommasterGenreForId:[[[SharedClass sharedInstance] selectedGenresArr] objectAtIndex:0]];
        }
        
    }
    else {
        
        self.backButtonLeftConstraint.constant = -65;
        [self.refreshButton setHidden:NO];
        newsArr = [[DBManager sharedManager] getAllNews];

    }
    
    for (int i = 0; i < newsArr.count; i++) {
        
        [_photoModelsDatasource addObject:[CardModal modelWithNews:[newsArr objectAtIndex:i]]];
        
    }
    
    [_photosCollectionView reloadData];
    [_photosCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
}




#pragma mark - API Handling

-(void) startGetNewsContentService {
    
    [self.view makeToast:@"Refreshing news content"];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetNewsContent;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForNewsContent]];
    
}

#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(NewsContentResponseObject *)responseData andServiceKey:(NSString *)requestServiceKey {
    
    if ([requestServiceKey isEqualToString:kGetNewsContent]) {
        
        
        //[self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
        
    }
    
}


-(void) didFinishServiceWithFailure:(NSString *)errorMsg {
    
    [SVProgressHUD dismiss];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Server error"
                                                  message:@"Request timed out, please try again later."
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles: nil];
    
    if (![errorMsg isEqualToString:@""]) {
        [alert setMessage:errorMsg];
    }
    
    [alert show];
    
    return;
    
}

-(void) didUpdateLatestNewsContent {
    
    [self.view makeToast:@"News content updated succesfully"];
    [self generateDatasource];
    
}


#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForNewsContent {
    
    NewsContentRequestObject* requestObj = [[NewsContentRequestObject alloc] init];
    requestObj.userId = [[SharedClass sharedInstance] userId];
    
    if ([[[DBManager sharedManager] getAllSettings] valueForKey:timestampKey]) {
        requestObj.timestamp = [[[DBManager sharedManager] getAllSettings] valueForKey:timestampKey];
    }
    else {
        requestObj.timestamp = @"";
    }
    
    return [requestObj createRequestDictionary];
    
}





#pragma mark - UICollectionViewDelegate/Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoModelsDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCellIdentifier
                                                                                             forIndexPath:indexPath];
    [cell setCardModel:_photoModelsDatasource[indexPath.row]];
    //cell.cardView.layer.cornerRadius = 10.0;
    [cell.cardView.layer setMasksToBounds:YES];
    
    cell.cardView.clipsToBounds = NO;
    cell.cardView.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.cardView.layer.shadowOffset = CGSizeMake(0,5);
    cell.cardView.layer.shadowOpacity = 0.5;
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    cell.delegate = self;
    
    SingleNewsObject* newsObj = (SingleNewsObject *)[newsArr objectAtIndex:indexPath.row];
    
    if (!newsObj.detailedStory || [newsObj.detailedStory isEqualToString:@""]) {
        [cell.expandButton setHidden:YES];
    }
    else {
        [cell.expandButton setHidden:NO];
    }
    
    //selectedIndex = indexPath.row;
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width - 20, collectionView.frame.size.height - 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _photosCollectionView.frame.size.width;
    int currentPage = floor(_photosCollectionView.contentOffset.x / pageWidth);
    selectedIndex = currentPage;
    
}



#pragma mark - CustomCollectionViewCell Delegate

- (void) bookmarkRemoved {
    
    [self.view makeToast:@"Removed form bookmark."];
    
}


- (void) bookmarkAdded {
    
    [self.view makeToast:@"Bookmark Added successfully."];
    
}

- (void) bookmarkLimitReached {
    
    [self.view makeToast:@"Bookmark cannot be added. Maximum limit of 25 reached."];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)expandButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"showDetailSegue" sender:nil];
}

- (IBAction)shareButtonTapped:(id)sender {
    
    SingleNewsObject* newsObj = (SingleNewsObject *)[newsArr objectAtIndex:selectedIndex];
    
    CustomCollectionViewCollectionViewCell* cell = (CustomCollectionViewCollectionViewCell *)[_photosCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    
    [self shareText:[NSString stringWithFormat:@"%@.\n\n\%@.\n\nvia HappPost\n\n",newsObj.heading,newsObj.subHeading] andImage:cell.newsImageView.image andUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", HappPostShareURL, newsObj.newsId]]];
    
}


- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void) viewTapped {
    
    if (isNavigationViewShown) {
        self.navigationMenuHeightConstraint.constant = 0.0f;
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {}];
    }
    else {
        self.navigationMenuHeightConstraint.constant = 64.0f;
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {}];
    }
    
    isNavigationViewShown = !isNavigationViewShown;
    
}

#pragma mark - Menu Button Events

- (IBAction)menuButtonTapped:(id)sender {
    
    [menuView removeFromSuperview];
    [self setupMenuView];
    
    [self showMenuView];
    
}

- (IBAction)refreshButtonTapped:(id)sender {
    
    isRefreshButtonTapped = true;
    [self startGetNewsContentService];
    
}

- (IBAction)backButtonTapped:(id)sender {
    
    [[SharedClass sharedInstance] setMenuOptionType:0];
    [[SharedClass sharedInstance] setSelectedGenresArr:[[NSMutableArray alloc] init]];
    //[[SharedClass sharedInstance] setSelectedMyNewsArr:[[NSMutableArray alloc] init]];
    [self generateDatasource];
    
}

-(void) switchViewButtonTapped {
    [self hideMenuView];
    [self performSegueWithIdentifier:@"showListViewSegue" sender:nil];
}

- (void) bookmarkButtonTapped {
    
    [self hideMenuView];
    [self performSegueWithIdentifier:@"showBookmarkSegue" sender:nil];
    
}

- (void) genreCellSelected {
    
    [self hideMenuView];
    
}

- (void) myNewsSectionSelected {
    
    [[SharedClass sharedInstance] setMenuOptionType:2];
    [self hideMenuView];
    
}

- (void) aboutUsTapped {
    
    webViewSegueType = 0;
    [self performSegueWithIdentifier:@"showWebViewSegue" sender:nil];
    
}

- (void) privacyPolicyTapped {
    
    webViewSegueType = 1;
    [self performSegueWithIdentifier:@"showWebViewSegue" sender:nil];
    
}


- (void) showMenuView {
    
    [self.view addSubview:blurEffectView];
    [self.view addSubview:menuView];
    
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
        menuView.transform = CGAffineTransformScale(self.view.transform, 1, 1);
        menuView.alpha = 1.;
        menuView.center = menuView.center;
    } completion:^(BOOL finished) {}];
    
}

- (void) hideMenuView {
    
    [self generateDatasource];
    
    [blurEffectView removeFromSuperview];
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
        menuView.transform = CGAffineTransformScale(self.view.transform, 3, 3);
        menuView.alpha = 0.;
        menuView.center = menuView.center;
    } completion:^(BOOL finished) {
        
        [menuView removeFromSuperview];
        
    }];
    
}


#pragma mark - Search Bar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self hideMenuView];
    [[SharedClass sharedInstance] setSearchText:searchBar.text];
    //[[SharedClass sharedInstance] setMenuOptionType:1];
    //[self generateDatasource];
    [self performSegueWithIdentifier:@"showSearchSegue" sender:nil];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        [menuView endEditing:YES];
    }
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        
        ContentDetailViewController* controller = (ContentDetailViewController *)[segue destinationViewController];
        
        [controller setNewsObj:(SingleNewsObject *)[newsArr objectAtIndex:selectedIndex]];
        
    }
    if ([segue.identifier isEqualToString:@"showWebViewSegue"]) {
        
        WebViewController* controller = (WebViewController *)[segue destinationViewController];
        
        if (webViewSegueType == 0) {
            [controller setWebViewTitle:@"About Us"];
            [controller setWebViewURL:AboutUsURL];
        }
        else {
            [controller setWebViewTitle:@"Privacy Policy"];
            [controller setWebViewURL:PrivacyPolicyURL];
        }
        
        
    }
    
}

@end
