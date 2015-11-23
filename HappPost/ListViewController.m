//
//  ListViewController.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 17/11/15.
//  Copyright (c) 2015 Star Deep. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewTableViewCell.h"
#import "MenuView.h"
#import "MenuTableViewCell.h"

@interface ListViewController () {
    MenuView* menuView;
    UIVisualEffectView *blurEffectView;
}

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
    menuView = [subviewArray objectAtIndex:0];
    menuView.menuTableView.dataSource = self;
    menuView.menuTableView.delegate = self;
    menuView.frame = self.view.frame;
    menuView.transform = CGAffineTransformScale(self.view.transform, 3, 3);
    menuView.alpha = 0.0;
    [menuView.closeButton addTarget:self action:@selector(hideMenuView) forControlEvents:UIControlEventTouchUpInside];
    [menuView.switchToCardView addTarget:self action:@selector(switchViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menuView.menuTableView) {
        
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
    
    NSString* identifier = @"ListCell";
    ListViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ListViewTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    cell.newsImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tmp%ld",(indexPath.row%4)+1]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menuView.menuTableView) {
        return 50.0;
    }
    return 150.0;
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchViewButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
}

- (IBAction)menuButtonTapped:(id)sender {
    
    [self showMenuView];
    
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
