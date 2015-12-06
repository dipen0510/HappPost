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
    
    /*self.navigationMenuHeightConstraint.constant = 0.0;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGesture];*/
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
    menuView = [subviewArray objectAtIndex:0];
    menuView.frame = self.view.frame;
    menuView.transform = CGAffineTransformScale(self.view.transform, 3, 3);
    menuView.alpha = 0.0;
    [menuView.closeButton addTarget:self action:@selector(hideMenuView) forControlEvents:UIControlEventTouchUpInside];
    [menuView.switchToCardView addTarget:self action:@selector(switchViewButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuView.switchToCardView setTitle:@"Switch To List View" forState:UIControlStateNormal];
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    
}


- (void)viewWillAppear:(BOOL)animated {
    [self generateDatasource];
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
}

#pragma mark - Private

- (void)generateDatasource {
    
    _photoModelsDatasource = [[NSMutableArray alloc] init];
    
    newsArr = [[NSMutableArray alloc] init];
    newsArr = [[DBManager sharedManager] checkAndFetchNews];
    
    for (int i = 0; i < newsArr.count; i++) {
        
        [_photoModelsDatasource addObject:[CardModal modelWithNews:[newsArr objectAtIndex:i]]];
        
    }
    
    [_photosCollectionView reloadData];
    
}


#pragma mark - UICollectionViewDelegate/Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoModelsDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCellIdentifier
                                                                                             forIndexPath:indexPath];
    [cell setCardModel:_photoModelsDatasource[indexPath.row]];
    cell.cardView.layer.cornerRadius = 10.0;
    [cell.cardView.layer setMasksToBounds:YES];
    
    cell.cardView.clipsToBounds = NO;
    cell.cardView.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.cardView.layer.shadowOffset = CGSizeMake(0,5);
    cell.cardView.layer.shadowOpacity = 0.5;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)expandButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"showDetailSegue" sender:nil];
}

- (IBAction)shareButtonTapped:(id)sender {
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
    
    [self showMenuView];
    
}

-(void) switchViewButtonTapped {
    [self hideMenuView];
    [self performSegueWithIdentifier:@"showListViewSegue" sender:nil];
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        
        ContentDetailViewController* controller = (ContentDetailViewController *)[segue destinationViewController];
        
        [controller setNewsObj:(SingleNewsObject *)[newsArr objectAtIndex:selectedIndex]];
        
    }
    
}

@end
