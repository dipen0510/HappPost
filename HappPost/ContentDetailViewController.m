//
//  ContentDetailViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 25/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "DetailContentCollectionViewCell.h"

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
    self.secondaryDescriptionLabel.text = newsObj.summary;
    
    [self adjustHeightForLabel:self.headingLabel andConstraint:self.headingHeightConstraint];
    [self adjustHeightForLabel:self.subheadingLabel andConstraint:self.subheadingHeightCoonstraint];
    [self adjustHeightForLabel:self.primaryDescriptionLabel andConstraint:self.primaryDescriptionHeightConstraint];
    [self adjustHeightForLabel:self.secondaryDescriptionLabel andConstraint:self.scondaryDescriptionHeadingConstraint];
    
    [self downloadPrimaryNewsImagewithURL:newsObj.newsImage];
    
    if (newsObj.newsInfographics.count > 0) {
        
        secondaryImageNewsInfogrphicsObj = (NewsInfographicsObject *) [newsObj.newsInfographics objectAtIndex:0];
        
        if ([self isVideoURL:secondaryImageNewsInfogrphicsObj.newsImage]) {
            
            
            
        }
        else {
            
            [self downloadSecondaryNewsImagewithURL:secondaryImageNewsInfogrphicsObj.newsImage];
            
        }
        
    }
    else {
        
        
        
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
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailContentCollectionViewCell *cell = (DetailContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
    
    [self generateContentForCell:cell andIndexPath:indexPath];
    
    return cell;
    
}


- (void) generateContentForCell:(DetailContentCollectionViewCell *)cell andIndexPath:(NSIndexPath *)indexPath {

    
    NSString* imgURL = newsObj.newsImage;
    
    if (indexPath.row == 0) {
        imgURL = @"http://images.indianexpress.com/2015/05/russia_759.jpg";
    }
    else if (indexPath.row == 1){
        imgURL = @"http://magazine.providence.edu/wp-content/uploads/2014/01/pc-news-joe-day.jpg";
    }
    else {
        imgURL = @"http://www.bbc.co.uk/news/special/world/11/911_timeline/img/splash-image-976x482-2.jpg";
    }
    
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
