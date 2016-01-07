//
//  ListViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 17/11/15.
//  Copyright (c) 2015 Star Deep. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewTableViewCell.h"
#import "MenuView.h"
#import "ContentDetailViewController.h"
#import "SearchListViewController.h"

@interface ListViewController () {
    MenuView* menuView;
    UIVisualEffectView *blurEffectView;
}

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.listTblView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    // Set screen name.
    // Set screen name.
    [[GoogleAnalyticsHelper sharedInstance] sendScreenTrackingWithName:@"News List Screen"];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self generateDatasourceForList];
    
}

- (void) refreshTable {
    
    [self startGetNewsContentService];
    
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
    [menuView.switchToCardView setTitle:@"Switch To Card View" forState:UIControlStateNormal];
    
}

- (void) generateDatasourceForList {
    
    newsContentArr = [[NSMutableArray alloc] init];
    self.menuTitle.text = @"";
    
    if ([[SharedClass sharedInstance] menuOptionType] == 1) {
        
        self.backButtonLeftConstraint.constant = 8;
        [self.refreshButton setHidden:YES];
        newsContentArr = [[DBManager sharedManager] getAllNewsForSearchedText:[[SharedClass sharedInstance] searchText]];
        self.menuTitle.text = @"Search";
        
    }
    else if ([[SharedClass sharedInstance] menuOptionType] == 2) {
        
        self.backButtonLeftConstraint.constant = 8;
        [self.refreshButton setHidden:YES];
        newsContentArr = [[DBManager sharedManager] checkAndFetchNews];
        
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
        newsContentArr = [[DBManager sharedManager] getAllNews];
        
    }
    
    
    [self.listTblView reloadData];
    //[self.listTblView setContentOffset:CGPointZero animated:YES];
    
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
    
    [refreshControl endRefreshing];
    
    if ([requestServiceKey isEqualToString:kGetNewsContent]) {
        
        //[self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
        
    }
    
}


-(void) didFinishServiceWithFailure:(NSString *)errorMsg {
    
    [SVProgressHUD dismiss];
    [refreshControl endRefreshing];
    
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
    [self generateDatasourceForList];
    
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



#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return newsContentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* identifier = @"ListCell";
    ListViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ListViewTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    [self generateContentForCell:cell andIndexPath:(NSIndexPath *)indexPath];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 150.0;
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];

        selectedIndex = indexPath.row;
        [self performSegueWithIdentifier:@"showDetailSegue" sender:nil];

    
}

- (void) generateContentForCell:(ListViewTableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath {
    
    SingleNewsObject* newsObj = (SingleNewsObject *) [newsContentArr objectAtIndex:indexPath.row];
    
    cell.newsHeading.text = newsObj.heading;
    cell.newsDescription.text = newsObj.subHeading;
    cell.newsTime.text = [[[SharedClass sharedInstance] dateFromString:newsObj.activeFrom] timeAgo];
    
    NSString* imgURL = newsObj.newsImage;
    
    if ([self isVideoURL:imgURL]) {
        
        NSString* videoURl = [[imgURL componentsSeparatedByString:@"/"] lastObject];
        if ([videoURl containsString:@"watch"]) {
            
            videoURl = [[videoURl componentsSeparatedByString:@"="] lastObject];
            
        }
        
        [cell.playerView setBackgroundColor:[UIColor blackColor]];
        [cell.playerView loadWithVideoId:videoURl];
        cell.playerView.delegate = self;
        [cell.playerView setHidden:NO];
        [cell.newsImgView setHidden:YES];
        
    }
    else {
        [cell.newsImgView setHidden:NO];
        [cell.playerView setHidden:YES];
        
        cell.newsImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        if(![imgURL isEqualToString:@""])
        {
            NSString* urlTextEscaped = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlTextEscaped];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
            
            __weak UIImageView *weakImgView = cell.newsImgView;
            
            [cell.newsImgView setImageWithURLRequest:request
                                    placeholderImage:placeholderImage
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 
                                                 weakImgView.image = image;
                                                 [weakImgView setNeedsLayout];
                                                 
                                             } failure:nil];
            
        }
        
    }
    
    
    
}


- (BOOL) isVideoURL:(NSString *)url {
    
    if ([url containsString:@"youtu"]) {
        return true;
    }
    return false;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Menu Button Events

- (IBAction)menuButtonTapped:(id)sender {
    
    [menuView removeFromSuperview];
    [self setupMenuView];
    [self showMenuView];
    
}

- (IBAction)refreshButtonTapped:(id)sender {
    
    [self startGetNewsContentService];
    
}

-(void) switchViewButtonTapped {
    [self hideMenuView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) bookmarkButtonTapped {
    
    [self hideMenuView];
    [self performSegueWithIdentifier:@"showBookmarkSegue" sender:nil];
  
}

- (IBAction)backButtonTapped:(id)sender {
    
    [[SharedClass sharedInstance] setMenuOptionType:0];
    [[SharedClass sharedInstance] setSelectedGenresArr:[[NSMutableArray alloc] init]];
    //[[SharedClass sharedInstance] setSelectedMyNewsArr:[[NSMutableArray alloc] init]];
    [self generateDatasourceForList];
    
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
    
    [self generateDatasourceForList];
    
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
    //[self generateDatasourceForList];
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
        
        [controller setNewsObj:(SingleNewsObject *)[newsContentArr objectAtIndex:selectedIndex]];
        
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




#pragma mark - Youtube Player Delegates

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    
    
    
    
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{}
- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality{}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{}


@end
