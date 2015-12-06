//
//  AddCommentsTableViewCell.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 06/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentsTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *addCommentTextView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
