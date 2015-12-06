//
//  AddCommentsTableViewCell.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 06/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import "AddCommentsTableViewCell.h"

@implementation AddCommentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2.0;
    self.addCommentTextView.layer.borderColor = [self.profileImageView.backgroundColor CGColor];
    self.addCommentTextView.layer.borderWidth = 1.3;
    self.addCommentTextView.layer.cornerRadius = 10.;
    self.addCommentTextView.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UITextView Delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.addCommentTextView.text = @"";
    self.addCommentTextView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.addCommentTextView.text.length == 0){
        self.addCommentTextView.textColor = [UIColor lightGrayColor];
        self.addCommentTextView.text = @"Comment";
        [self.addCommentTextView resignFirstResponder];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    [self.addCommentTextView resignFirstResponder];
    
}

@end
