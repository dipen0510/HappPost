//
//  MenuView.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 24/11/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "MenuView.h"
#import "MenuTableViewCell.h"

@implementation MenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    //[self.mewnuScrollView setContentSize:CGSizeMake(300, 1200)];
    self.mewnuScrollView.delegate = self;
    [self.mewnuScrollView setShowsHorizontalScrollIndicator:NO];
    
    selectedGenreArr = [[NSMutableArray alloc] init];
    selectedMyNewsArr = [[NSMutableArray alloc] init];
    
    selectedGenreArr = [[SharedClass sharedInstance] selectedGenresArr];
    selectedMyNewsArr = [[SharedClass sharedInstance] selectedMyNewsArr];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
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
    
    if (tableView == self.genreTableView) {
        
        if ([selectedGenreArr containsObject:indexPath]) {
            cell.backgroundColor = [UIColor colorWithRed:251./255 green:193./255 blue:21./255 alpha:0.8];
        }
        else {
            cell.backgroundColor = [UIColor clearColor];
        }
        
    }
    else {
        
        if ([selectedMyNewsArr containsObject:indexPath]) {
            cell.backgroundColor = [UIColor colorWithRed:251./255 green:193./255 blue:21./255 alpha:0.8];
        }
        else {
            cell.backgroundColor = [UIColor clearColor];
        }
        
    }
    
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-20, 0, tableView.frame.size.width, 33)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:17.0]];
    [label setTextColor:[UIColor whiteColor]];
    
    NSString *string = @"";
    
    if (tableView == self.genreTableView) {
        string = @"Genres";
    }
    else {
        string = @"My News";
    }
    
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 33.;
    
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (tableView == self.genreTableView) {
        
        if ([selectedGenreArr containsObject:indexPath]) {
            [selectedGenreArr removeObject:indexPath];
        }
        else {
            [selectedGenreArr removeAllObjects];
            [selectedMyNewsArr removeAllObjects];
            [selectedGenreArr addObject:indexPath];
        }
        
    }
    else {
        
        if ([selectedMyNewsArr containsObject:indexPath]) {
            [selectedMyNewsArr removeObject:indexPath];
        }
        else {
            [selectedGenreArr removeAllObjects];
            [selectedMyNewsArr addObject:indexPath];
        }
        
    }
    
    [[SharedClass sharedInstance] setSelectedGenresArr:selectedGenreArr];
    [[SharedClass sharedInstance] setSelectedMyNewsArr:selectedMyNewsArr];
    
    [self.genreTableView reloadData];
    [self.menuTableView reloadData];
    
}


@end
