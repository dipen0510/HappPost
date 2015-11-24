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

// Model
#import "PhotoModel.h"

// Cells
#import "CustomCollectionViewCollectionViewCell.h"
#import "MenuView.h"
#import "MenuTableViewCell.h"

@interface CardContentViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>{
    MenuView* menuView;
    UIVisualEffectView *blurEffectView;
}

@end

@implementation CardContentViewController {
    NSArray *_photoModelsDatasource;
    
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
    
    [self generateDatasource];
    
    self.navigationMenuHeightConstraint.constant = 0.0;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
    menuView = [subviewArray objectAtIndex:0];
    menuView.menuTableView.dataSource = self;
    menuView.menuTableView.delegate = self;
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
    _photoModelsDatasource = @[[PhotoModel modelWithImageNamed:@"nature1"
                                                   description:@"Lake and forest."],
                               [PhotoModel modelWithImageNamed:@"nature2"
                                                   description:@"Beautiful bench."],
                               [PhotoModel modelWithImageNamed:@"nature3"
                                                   description:@"Sun rays going through trees."],
                               [PhotoModel modelWithImageNamed:@"nature4"
                                                   description:@"Autumn Road."],
                               [PhotoModel modelWithImageNamed:@"nature5"
                                                   description:@"Outstanding Waterfall."],
                               [PhotoModel modelWithImageNamed:@"nature6"
                                                   description:@"Different Seasons."],
                               [PhotoModel modelWithImageNamed:@"nature7"
                                                   description:@"Home near lake."],
                               [PhotoModel modelWithImageNamed:@"nature8"
                                                   description:@"Perfect Mirror."],
                               [PhotoModel modelWithImageNamed:@"smtng"
                                                   description:@"Interesting formula."],];
}

#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        
        NSString* identifier = @"MenuView";
        MenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        switch (indexPath.row) {
            case 0:
                cell.categoryLabel.text = @"India";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"india"]];
                break;
                
            case 1:
                cell.categoryLabel.text = @"World";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"world"]];
                break;
                
            case 2:
                cell.categoryLabel.text = @"Sport";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"sports"]];
                break;
                
            case 3:
                cell.categoryLabel.text = @"Entertainment";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"entertainment"]];
                break;
                
            case 4:
                cell.categoryLabel.text = @"Business";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"business"]];
                break;
                
            case 5:
                cell.categoryLabel.text = @"Life/Style";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"lifestyle"]];
                break;
                
            case 6:
                cell.categoryLabel.text = @"Spotlight";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"spotlight"]];
                break;
                
            case 7:
                cell.categoryLabel.text = @"Special";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"special"]];
                break;
                
            case 8:
                cell.categoryLabel.text = @"Trending";
                cell.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"trending"]];
                break;
                
            default:
                break;
        }
        
        return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   return 50.0;
    
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}



#pragma mark - UICollectionViewDelegate/Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoModelsDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomCellIdentifier
                                                                                             forIndexPath:indexPath];
    cell.photoModel = _photoModelsDatasource[indexPath.row];
    cell.cardView.layer.cornerRadius = 10.0;
    [cell.cardView.layer setMasksToBounds:YES];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switcchToCardContentButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [blurEffectView removeFromSuperview];
    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
        menuView.transform = CGAffineTransformScale(self.view.transform, 3, 3);
        menuView.alpha = 0.;
        menuView.center = menuView.center;
    } completion:^(BOOL finished) {
        
        [menuView removeFromSuperview];
        
    }];
    
}


@end
