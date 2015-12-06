//
//  HPTopLeftLabel.h
//  HappPost
//
//  Created by Dipen Sekhsaria on 06/12/15.
//  Copyright © 2015 Star Deep. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface HPTopLeftLabel : UILabel

 @property (nonatomic, readwrite) VerticalAlignment verticalAlignment;

@end
