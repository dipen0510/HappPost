//
//  ContentDetailViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 25/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "DetailContentCollectionViewCell.h"
#import "AddCommentsTableViewCell.h"
#import "UserCommenstsTableViewCell.h"
#import "NewsCommentObject.h"
#import "AddCommentRequestObject.h"

@interface ContentDetailViewController ()

@end

@implementation ContentDetailViewController

@synthesize newsObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 70., self.contentScrollView.frame.size.width + 50., self.secondaryImageView.frame.origin.y + self.secondaryImageView.frame.size.height/2.);
    gradient.colors = [NSArray arrayWithObjects:(id)[self.navigationView.backgroundColor CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.contentScrollView.layer insertSublayer:gradient atIndex:0];
    
    [self generateContent];
    
    if ([self iPhone6PlusUnZoomed]) {
        self.primaryDescriptionTopConstraint.constant = 305;
    }
    
    commentArr = [[NSMutableArray alloc] initWithArray:newsObj.newsComments];
    
    
    // Set screen name.
    [[GoogleAnalyticsHelper sharedInstance] sendScreenTrackingWithName:@"News Detail Screen"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) iPhone6PlusUnZoomed{
    if ([self iPhone6PlusDevice]){
        if ([UIScreen mainScreen].bounds.size.height > 720.0) return YES;  // Height is 736, but 667 when zoomed.
    }
    return NO;
}


-(BOOL)iPhone6PlusDevice{
    if ([UIScreen mainScreen].scale > 2.9) return YES;   // Scale is only 3 when not in scaled mode for iPhone 6 Plus
    return NO;
}



-(void) generateContent {
    
    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBookmarkTapForNewsId:)];
    gesture.numberOfTouchesRequired = 1;
    [self.headingLabel addGestureRecognizer:gesture];
    [self.headingLabel setUserInteractionEnabled:YES];
    
    self.headingLabel.text = newsObj.heading;
    self.subheadingLabel.text = newsObj.subHeading;
    
    if (newsObj.detailedStory) {
        self.secondaryDescriptionLabel.text = newsObj.detailedStory;
        self.primaryDescriptionLabel.text = @"";
    }
    else {
        self.secondaryDescriptionLabel.text = @"";
        self.primaryDescriptionLabel.text = newsObj.summary;
    }
    
    
    self.authorNameLabel.text = newsObj.authorName;
    self.dateTimeLabel.text = newsObj.dateCreated;
    
    [self adjustHeightForLabel:self.headingLabel andConstraint:self.headingHeightConstraint];
    [self adjustHeightForLabel:self.subheadingLabel andConstraint:self.subheadingHeightCoonstraint];
    [self adjustHeightForLabel:self.primaryDescriptionLabel andConstraint:self.primaryDescriptionHeightConstraint];
    [self adjustHeightForLabel:self.secondaryDescriptionLabel andConstraint:self.scondaryDescriptionHeadingConstraint];
    
    
    if (![[DBManager sharedManager] isNewsIdBookmarked:newsObj.newsId]) {
        
        [self.headingLabel setTextColor:[UIColor blackColor]];
        
    }
    else {
        
        [self.headingLabel setTextColor:[UIColor whiteColor]];
        
    }
    
    //Primary Video Check
    
    if ([self isVideoURL:newsObj.webImage]) {
        
        [self.primaryVideoPlayerView setHidden:YES];
        
        NSString* videoURl = [[newsObj.webImage componentsSeparatedByString:@"/"] lastObject];
        if ([videoURl containsString:@"watch"]) {
            
            videoURl = [[videoURl componentsSeparatedByString:@"="] lastObject];
            
        }
        
        [self.primaryVideoPlayerView loadWithVideoId:videoURl];
        self.primaryVideoPlayerView.delegate = self;
        
        self.primaryImageView.image = [UIImage imageNamed:@"videoPlayerPlaceholder.png"];
        
    }
    else {
        
        [self.primaryVideoPlayerView setHidden:YES];
        //self.primaryVideoPlayerView.contentMode = UIViewContentModeScaleAspectFill;
        [self downloadPrimaryNewsImagewithURL:newsObj.webImage];
        
    }
    
    
    //Secondary Video Check
    
    if (newsObj.secondLeadImage) {
        
        if ([self isVideoURL:newsObj.secondLeadImage]) {
            
            [self.videoPlayerView setHidden:YES];
            
            NSString* videoURl = [[newsObj.secondLeadImage componentsSeparatedByString:@"/"] lastObject];
            if ([videoURl containsString:@"watch"]) {
                
                videoURl = [[videoURl componentsSeparatedByString:@"="] lastObject];
                
            }
            
            [self.videoPlayerView loadWithVideoId:videoURl];
            self.videoPlayerView.delegate = self;
            
            self.secondaryImageView.image = [UIImage imageNamed:@"videoPlayerPlaceholder.png"];
            
        }
        else {
            
            [self.videoPlayerView setHidden:YES];
           // self.secondaryImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self downloadSecondaryNewsImagewithURL:newsObj.secondLeadImage];
            
        }
        
    }
    else {
        
        [self.videoPlayerView setHidden:YES];
        [self.secondaryImageView setHidden:YES];
        self.primaryDescriptionTopConstraint.constant = 69.;
        
    }
    
    
    
}

- (void) adjustHeightForLabel:(UILabel *)label andConstraint:(NSLayoutConstraint *)constraint {
    
//    label.numberOfLines = 0;
//    
//    //Calculate the expected size based on the font and linebreak mode of your label
//    // FLT_MAX here simply means no constraint in height
//    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
//    
//    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
//    
//    //adjust the label the the new height.
    
    CGSize size = [label sizeOfMultiLineLabel];
    
    constraint.constant = size.height + 20.;
    if (constraint.constant<40.0) {
        constraint.constant = 20.0;
    }
    
    
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        if (label == self.secondaryDescriptionLabel || label == self.primaryDescriptionLabel) {
            constraint.constant = constraint.constant + (constraint.constant * 0.15);
        }
    }
    
    
    
}


#pragma mark - Youtube Player Delegates

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    
    
    if (playerView == self.videoPlayerView) {
        [self.videoPlayerView setHidden:NO];
        [self.secondaryImageView setHidden:YES];
    }
    
    if (playerView == self.primaryVideoPlayerView) {
        [self.primaryVideoPlayerView setHidden:NO];
        [self.primaryImageView setHidden:YES];
    }
    
    
    
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{}
- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality{}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{}


-(void) downloadPrimaryNewsImagewithURL:(NSString *)imgURL {
    
    if(![imgURL isEqualToString:@""])
    {
        NSString* urlTextEscaped = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlTextEscaped];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UIImageView *weakImgView = self.primaryImageView;
        
        [self.primaryImageView setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            
                                            weakImgView.image = image;
                                            [weakImgView setNeedsLayout];
                                            
                                        } failure:nil];
        
    }
}

-(void) downloadSecondaryNewsImagewithURL:(NSString *)imgURL {
    
    if(![imgURL isEqualToString:@""])
    {
        NSString* urlTextEscaped = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlTextEscaped];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UIImageView *weakImgView = self.secondaryImageView;
        
        [self.secondaryImageView setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  
                                                  weakImgView.image = image;
                                                  [weakImgView setNeedsLayout];
                                                  
                                              } failure:nil];
        
    }
}


#pragma mark - CollectionView Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    long count = newsObj.newsInfographics.count ;
    
    if (count <= 0) {
        self.collectionViewHeightConstraint.constant = 0;
    }
    
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailContentCollectionViewCell *cell = (DetailContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
    
    [self generateContentForCell:cell andIndexPath:indexPath];
    
    return cell;
    
}


- (void) generateContentForCell:(DetailContentCollectionViewCell *)cell andIndexPath:(NSIndexPath *)indexPath {
    
        
        NewsInfographicsObject* newsInfoObj = (NewsInfographicsObject *)[newsObj.newsInfographics objectAtIndex:(indexPath.row)];
        
        NSString* imgURL = newsInfoObj.newsImage;
        
        if ([self isVideoURL:imgURL]) {
            
            NSString* videoURl = [[imgURL componentsSeparatedByString:@"/"] lastObject];
            if ([videoURl containsString:@"watch"]) {
                
                videoURl = [[videoURl componentsSeparatedByString:@"="] lastObject];
                
            }
            
            YTPlayerView* videPlayer = [[YTPlayerView alloc] initWithFrame:cell.frame];
            [videPlayer setBackgroundColor:[UIColor blackColor]];
            [videPlayer loadWithVideoId:videoURl];
            videPlayer.delegate = self;
            
            [cell addSubview:videPlayer];
            
            
        }
        else {
            
            cell.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            if(![imgURL isEqualToString:@""])
            {
                NSString* urlTextEscaped = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlTextEscaped];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
                
                __weak UIImageView *weakImgView = cell.contentImageView;
                
                [cell.contentImageView setImageWithURLRequest:request
                                             placeholderImage:placeholderImage
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                          
                                                          weakImgView.image = image;
                                                          [weakImgView setNeedsLayout];
                                                          
                                                      } failure:nil];
                
            }
            
        }
    
}


#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return commentArr.count + 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        NSString* identifier = @"AddCommentsView";
        AddCommentsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"AddCommentsTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        [cell.addButton addTarget:self action:@selector(addCommentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    
    NSString* identifier = @"UserCommentsView";
    UserCommenstsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"UserCommenstsTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    NewsCommentObject* commentObj = (NewsCommentObject *)[commentArr objectAtIndex:indexPath.row-1];
    
    cell.profileNameLbl.text = commentObj.user;
    cell.commentDateLbl.text = commentObj.dateCreated;
    cell.commentDescriptonLbl.text = commentObj.comments;
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 180.0;
    }
    
    NewsCommentObject* commentObj = (NewsCommentObject *)[commentArr objectAtIndex:indexPath.row-1];
    NSString *str = commentObj.comments;
    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",size.height);
    return size.height + 80;
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
    
}


- (void) addCommentButtonTapped {
    
    NSString* userId = [[SharedClass sharedInstance] userId];
    
    if (userId && [userId intValue]!=-1) {
        
        [self startAddCommentService];
        
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"Register first to add comment"];
        [self performSegueWithIdentifier:@"showRegisterSegue" sender:nil];
        
    }
    
}

#pragma mark - Add Comment API

-(void) startAddCommentService {
    
    [SVProgressHUD showWithStatus:@"Adding Comment"];
    
    AddCommentsTableViewCell* cell = (AddCommentsTableViewCell *)[self.commentsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.addCommentTextView resignFirstResponder];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kAddComment;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForAddComment]];
    
}


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(id)responseData andServiceKey:(NSString *)requestServiceKey {
    
    if ([requestServiceKey isEqualToString:kAddComment]) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"Comment Added"];
        
        AddCommentsTableViewCell* cell = (AddCommentsTableViewCell *)[self.commentsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.addCommentTextView setText:@""];
        
        commentArr = [[NSMutableArray alloc] initWithArray:[[DBManager sharedManager] getAllNewsCommentsForNewsId:newsObj.newsId]];
        
        [self.commentsTableView reloadData];
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

#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForAddComment {
    
    AddCommentRequestObject* requestObj = [[AddCommentRequestObject alloc] init];
    requestObj.userId = [[SharedClass sharedInstance] userId];
    requestObj.newsId = newsObj.newsId;
    requestObj.dateAndTime = [[[SharedClass sharedInstance] getUTCDateFormatter] stringFromDate:[NSDate date]];
    
    AddCommentsTableViewCell* cell = (AddCommentsTableViewCell *)[self.commentsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    requestObj.comments = cell.addCommentTextView.text;
    
    return [requestObj createRequestDictionary];
    
}


- (BOOL) isVideoURL:(NSString *)url {
    
    if ([url containsString:@"youtu"]) {
        return true;
    }
    return false;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    
    //[self share];
    [self shareText:[NSString stringWithFormat:@"%@.\n\n\%@.\n\nvia HappPost\n\n",newsObj.heading,newsObj.subHeading] andImage:self.primaryImageView.image andUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", HappPostShareURL, newsObj.newsId]]];
    
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

//- (void)share {
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmptmpimg.jpg"];
//    [UIImageJPEGRepresentation(self.primaryImageView.image, 1.0) writeToFile:path atomically:YES];
//    
//    UIDocumentInteractionController* _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
//    _documentInteractionController.delegate = self;
//    [_documentInteractionController presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
//}
//
//- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
//    if ([self isWhatsApplication:application]) {
//        NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmptmpimg.wai"];
//        [UIImageJPEGRepresentation(self.primaryImageView.image, 1.0) writeToFile:savePath atomically:YES];
//        controller.URL = [NSURL fileURLWithPath:savePath];
//        controller.UTI = @"net.whatsapp.image";
//    }
//}
//
//- (BOOL)isWhatsApplication:(NSString *)application {
//    if ([application rangeOfString:@"whats"].location == NSNotFound) { // unfortunately, no other way...
//        return NO;
//    } else {
//        return YES;
//    }
//}


- (void) handleBookmarkTapForNewsId:(UILongPressGestureRecognizer *)gesture {
    
    
    if(UIGestureRecognizerStateBegan == gesture.state) {
        // Called on start of gesture, do work here
        
        if ([[DBManager sharedManager] isNewsIdBookmarked:newsObj.newsId]) {
            
            [self.headingLabel setTextColor:[UIColor blackColor]];
            [[DBManager sharedManager] deleteBookmarksWithNewsId:newsObj.newsId];
            
            [self.view makeToast:@"Removed form bookmark."];
            
        }
        else {
            
            if ([[[DBManager sharedManager] getAllNewsWithBookmarks] count] >= 25) {
                
                [self.view makeToast:@"Bookmark cannot be added. Maximum limit of 25 reached."];
                
            }
            else {
                
                [self.headingLabel setTextColor:[UIColor whiteColor]];
                [[DBManager sharedManager] insertEntryIntoBookmarksWithNewsId:newsObj.newsId];
                
                [self.view makeToast:@"Bookmark Added successfully."];
                
            }
            
        }
        
    }
    
    if(UIGestureRecognizerStateChanged == gesture.state) {
        // Do repeated work here (repeats continuously) while finger is down
    }
    
    if(UIGestureRecognizerStateEnded == gesture.state) {
        // Do end work here when finger is lifted
    }
    
    
}

@end
