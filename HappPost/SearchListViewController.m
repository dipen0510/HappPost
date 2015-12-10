//
//  SearchListViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 10/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "SearchListViewController.h"
#import "ListViewTableViewCell.h"
#import "ContentDetailViewController.h"

@interface SearchListViewController ()

@end

@implementation SearchListViewController

@synthesize searchText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self generateDatasourceForList];
}

- (void) generateDatasourceForList {
    
    newsContentArr = [[NSMutableArray alloc] init];
    newsContentArr = [[DBManager sharedManager] getAllNewsForSearchedText:searchText];
    [self.listTblView reloadData];
    
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

- (BOOL) isVideoURL:(NSString *)url {
    
    if ([url containsString:@"youtu"]) {
        return true;
    }
    return false;
    
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


@end
