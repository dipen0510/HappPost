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
    NSString* searchText;
}

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
    menuView = [subviewArray objectAtIndex:0];
    menuView.frame = self.view.frame;
    menuView.transform = CGAffineTransformScale(self.view.transform, 3, 3);
    menuView.alpha = 0.0;
    [menuView.closeButton addTarget:self action:@selector(hideMenuView) forControlEvents:UIControlEventTouchUpInside];
    [menuView.switchToCardView addTarget:self action:@selector(switchViewButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuView.myBookbarkButton addTarget:self action:@selector(bookmarkButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    menuView.searchBar.delegate = self;
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set screen name.
    self.screenName = @"News List screen";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self generateDatasourceForList];
}

- (void) generateDatasourceForList {
    
    newsContentArr = [[NSMutableArray alloc] init];
    newsContentArr = [[DBManager sharedManager] checkAndFetchNews];
    [self.listTblView reloadData];
    [self.listTblView setContentOffset:CGPointZero animated:YES];
    
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
    [self generateDatasourceForList];
    
}


#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForNewsContent {
    
    NewsContentRequestObject* requestObj = [[NewsContentRequestObject alloc] init];
    requestObj.userId = [[SharedClass sharedInstance] userId];
    
    if (requestObj.timestamp) {
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
    cell.newsTime.text = [[[SharedClass sharedInstance] dateFromString:newsObj.dateCreated] timeAgo];
    
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
        
        if(![imgURL isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imgURL];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Menu Button Events

- (IBAction)menuButtonTapped:(id)sender {
    
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
    searchText = searchBar.text;
    [self performSegueWithIdentifier:@"showSearchSegue" sender:nil];
    
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
    if ([segue.identifier isEqualToString:@"showSearchSegue"]) {
        
        SearchListViewController* controller = (SearchListViewController *)[segue destinationViewController];
        
        [controller setSearchText:searchText];
        
    }
}


- (BOOL) isVideoURL:(NSString *)url {
    
    if ([url containsString:@"youtu"]) {
        return true;
    }
    return false;
    
}


#pragma mark - Youtube Player Delegates

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    
    
    
    
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{}
- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality{}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{}


@end
