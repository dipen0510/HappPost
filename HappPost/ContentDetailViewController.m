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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.secondaryImageView.frame.origin.y + self.secondaryImageView.frame.size.height/2.);
    gradient.colors = [NSArray arrayWithObjects:(id)[self.navigationView.backgroundColor CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.contentScrollView.layer insertSublayer:gradient atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailContentCollectionViewCell *cell = (DetailContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
    
    cell.contentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tmp%ld",(indexPath.row%4)+3]];
    
    return cell;
    
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
