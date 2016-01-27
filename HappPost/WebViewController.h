//
//  PGWebViewController.h
//  Happ Post
//
//  Created by Dipen Sekhsaria on 18/11/15.
//  Copyright © 2015 Stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSyncManager.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;

@property (strong, nonatomic) NSString* webViewURL;
@property (strong, nonatomic) NSString* webViewTitle;

- (IBAction)closeButtonTapped:(id)sender;

@end
