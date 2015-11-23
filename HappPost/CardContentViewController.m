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

@interface CardContentViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@end

@implementation CardContentViewController {
    NSArray *_photoModelsDatasource;
    
    __weak IBOutlet UICollectionView *_photosCollectionView;
    __weak IBOutlet YRCoverFlowLayout *_coverFlowLayout;
    
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
    
    _maxDegreeValueLabel.text = [NSString stringWithFormat:@"%.2f", _coverFlowLayout.maxCoverDegree];
    _coverDensityValueLabel.text = [NSString stringWithFormat:@"%.2f", _coverFlowLayout.coverDensity];
    
    [self generateDatasource];
    
    self.navigationMenuHeightConstraint.constant = 0.0;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGesture];
    
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

#pragma mark - Callbacks

- (IBAction)degreesSliderValueChanged:(UISlider *)sender {
    _coverFlowLayout.maxCoverDegree = sender.value;
    _maxDegreeValueLabel.text = [NSString stringWithFormat:@"%.2f", _coverFlowLayout.maxCoverDegree];
    
    [_photosCollectionView reloadData];
}

- (IBAction)densitySliderValueChanged:(UISlider *)sender {
    _coverFlowLayout.coverDensity = sender.value;
    _coverDensityValueLabel.text = [NSString stringWithFormat:@"%.2f", _coverFlowLayout.coverDensity];
    
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
@end
