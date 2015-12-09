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

@property (weak, nonatomic) IBOutlet UIView *navigationView;

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) generateContent {
    
    self.headingLabel.text = newsObj.heading;
    self.subheadingLabel.text = newsObj.subHeading;
    self.primaryDescriptionLabel.text = newsObj.summary;
    self.secondaryDescriptionLabel.text = newsObj.detailedStory;
    
    [self adjustHeightForLabel:self.headingLabel andConstraint:self.headingHeightConstraint];
    [self adjustHeightForLabel:self.subheadingLabel andConstraint:self.subheadingHeightCoonstraint];
    [self adjustHeightForLabel:self.primaryDescriptionLabel andConstraint:self.primaryDescriptionHeightConstraint];
    [self adjustHeightForLabel:self.secondaryDescriptionLabel andConstraint:self.scondaryDescriptionHeadingConstraint];
    
    [self downloadPrimaryNewsImagewithURL:newsObj.newsImage];
    
    if (newsObj.newsInfographics.count > 0) {
        
        secondaryImageNewsInfogrphicsObj = (NewsInfographicsObject *) [newsObj.newsInfographics objectAtIndex:0];
        
        if ([self isVideoURL:secondaryImageNewsInfogrphicsObj.newsImage]) {
            
            [self.videoPlayerView setHidden:YES];
            
            NSString* videoURl = [[secondaryImageNewsInfogrphicsObj.newsImage componentsSeparatedByString:@"/"] lastObject];
            if ([videoURl containsString:@"watch"]) {
                
                videoURl = [[videoURl componentsSeparatedByString:@"="] lastObject];
                
            }
            
            [self.videoPlayerView loadWithVideoId:videoURl];
            self.videoPlayerView.delegate = self;
            
            self.secondaryImageView.image = [UIImage imageNamed:@"videoPlayerPlaceholder.png"];
            
        }
        else {
            
            [self.videoPlayerView setHidden:YES];
            [self downloadSecondaryNewsImagewithURL:secondaryImageNewsInfogrphicsObj.newsImage];
            
        }
        
    }
    else {
        
        [self.videoPlayerView setHidden:YES];
        [self.secondaryImageView setHidden:YES];
        self.primaryDescriptionTopConstraint.constant = 14.;
        
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
    
}


#pragma mark - Youtube Player Delegates

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    
    
    if (playerView == self.videoPlayerView) {
        [self.videoPlayerView setHidden:NO];
        [self.secondaryImageView setHidden:YES];
    }
    
    
    
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{}
- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality{}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{}


-(void) downloadPrimaryNewsImagewithURL:(NSString *)imgURL {
    
    if(![imgURL isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:imgURL];
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
        NSURL *url = [NSURL URLWithString:imgURL];
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
    
    long count = (newsObj.newsInfographics.count - 1);
    
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
    
        
        NewsInfographicsObject* newsInfoObj = (NewsInfographicsObject *)[newsObj.newsInfographics objectAtIndex:(indexPath.row + 1)];
        
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
            
            if(![imgURL isEqualToString:@""])
            {
                NSURL *url = [NSURL URLWithString:imgURL];
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
    
    return newsObj.newsComments.count + 1;
    
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
    
    NewsCommentObject* commentObj = (NewsCommentObject *)[newsObj.newsComments objectAtIndex:indexPath.row-1];
    
    cell.profileNameLbl.text = commentObj.user;
    cell.commentDateLbl.text = commentObj.dateCreated;
    cell.commentDescriptonLbl.text = commentObj.comments;
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 180.0;
    }
    
    NewsCommentObject* commentObj = (NewsCommentObject *)[newsObj.newsComments objectAtIndex:indexPath.row-1];
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
@end
