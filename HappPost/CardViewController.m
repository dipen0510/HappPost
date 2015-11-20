//
//  ViewController.m
//  Example
//
//  Created by Jonathan Tribouharet
//

#import "CardViewController.h"

@interface CardViewController () {
}

@end

@implementation CardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.effect = JT3DScrollViewEffectDepth;
    
    self.scrollView.delegate = self; // Use only for animate nextButton and previousButton
    
    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
    
    self.nextButton.backgroundColor = [UIColor colorWithRed:33/255. green:158/255. blue:238/255. alpha:1.];
    self.nextButton.layer.cornerRadius = 5.;
    self.previousButton.layer.cornerRadius = 5.;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.scrollView removeFromSuperview];
    
}

- (void)createCardWithColor
{
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    
    CGFloat x = self.scrollView.subviews.count * width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    view.backgroundColor = [UIColor colorWithRed:253/255. green:218/255. blue:86/255. alpha:1.];
    view.layer.cornerRadius = 10.;
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height*.35)];
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:imgView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = imgView.bounds;
    maskLayer.path = maskPath.CGPath;
    imgView.layer.mask = maskLayer;
    
    //imgView.layer.cornerRadius = 10.;
    imgView.layer.masksToBounds = YES;
    imgView.image = [UIImage imageNamed:@"tmp6.png"];
    
    UILabel* imgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imgView.frame.size.height - 80, width * 0.75, 70.)];
    imgLabel.textColor = [UIColor colorWithRed:253/255. green:218/255. blue:86/255. alpha:1.];
    imgLabel.text = @"Lorem ipsum dolor sit amet";
    imgLabel.font = [UIFont systemFontOfSize:26.0 weight:UIFontWeightBlack];
    imgLabel.numberOfLines = 2;
    
    UILabel* headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imgView.frame.size.height + 10, width - 40, 60.)];
    headingLabel.textColor = [UIColor blackColor];
    headingLabel.text = @"Lorem ipsum dolor sit amet consectr adipisicing elit";
    headingLabel.font = [UIFont boldSystemFontOfSize:18.0];
    headingLabel.numberOfLines = 2;
    
    UILabel* authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, headingLabel.frame.origin.y + 60, width - 40, 30.)];
    authorLabel.textColor = [UIColor lightGrayColor];
    authorLabel.text = @"Swapnil Harkanth";
    authorLabel.font = [UIFont boldSystemFontOfSize:14.0];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(20, authorLabel.frame.origin.y + 30, 100, 3.)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.frame.origin.y + 10 , width - 30, height - (lineView.frame.origin.y + 40))];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, officia";
    descriptionLabel.font = [UIFont systemFontOfSize:16.0];
    descriptionLabel.numberOfLines = 20;

    
    [view addSubview:imgView];
    [view addSubview:imgLabel];
    [view addSubview:headingLabel];
    [view addSubview:authorLabel];
    [view addSubview:lineView];
    [view addSubview:descriptionLabel];
    
    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(x + width, height);
}

#pragma mark - SegmentControl

- (IBAction)didChangeMode:(UISegmentedControl *)sender
{
    JT3DScrollViewEffect effect;
    switch (sender.selectedSegmentIndex) {
        case 0:
            effect = JT3DScrollViewEffectCards;
            break;
        case 1:
            effect = JT3DScrollViewEffectCarousel;
            break;
        case 2:
            effect = JT3DScrollViewEffectDepth;
            break;
        case 3:
            effect = JT3DScrollViewEffectTranslation;
            break;
            
        default:
            break;
    }
    
    self.scrollView.effect = effect;
}

#pragma mark - Next / Previous buttons

- (IBAction)loadNextPage:(id)sender
{
    [self.scrollView loadNextPage:YES];
}

- (IBAction)loadPreviousPage:(id)sender
{
    [self.scrollView loadPreviousPage:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateButtons];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateButtons];
}

- (void)updateButtons
{
    if(self.scrollView.currentPage >= self.scrollView.subviews.count - 1){
        [self showPreviousButton];
    }
    else{
        [self showNextButton];
    }
}

- (void)showNextButton
{
    [UIView animateWithDuration:.3
                     animations:^{
                         self.leftNextButtonConstraint.constant = 40;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)showPreviousButton
{
    [UIView animateWithDuration:.3
                     animations:^{
                         self.leftNextButtonConstraint.constant = - CGRectGetWidth(self.view.frame);
                         [self.view layoutIfNeeded];
                     }];
}

- (IBAction)listViewButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
