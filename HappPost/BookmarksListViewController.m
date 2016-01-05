//
//  BookmarksListViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 08/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "BookmarksListViewController.h"
#import "ListViewTableViewCell.h"
#import "ContentDetailViewController.h"

@interface BookmarksListViewController ()

@end

@implementation BookmarksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Set screen name.
    [[GoogleAnalyticsHelper sharedInstance] sendScreenTrackingWithName:@"Bookmark List Screen"];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self generateDatasourceForList];
}

- (void) generateDatasourceForList {
    
    newsContentArr = [[NSMutableArray alloc] init];
    newsContentArr = [[DBManager sharedManager] getAllNewsWithBookmarks];
    [self.listTblView reloadData];
    
}

#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (newsContentArr.count < 1) {
        [self.emptyBookmarksLabel setHidden:NO];
        [self.listTblView setHidden:YES];
    }
    else {
        [self.emptyBookmarksLabel setHidden:YES];
        [self.listTblView setHidden:NO];
    }
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SingleNewsObject* newsObj = (SingleNewsObject *) [newsContentArr objectAtIndex:indexPath.row];
        
        [[DBManager sharedManager] deleteBookmarksWithNewsId:newsObj.newsId];
        
        [newsContentArr removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
    }
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
        [cell.playerView setHidden:NO];
        [cell.newsImgView setHidden:YES];
        
    }
    else {
        [cell.newsImgView setHidden:NO];
        [cell.playerView setHidden:YES];
        
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
