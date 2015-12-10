//
//  PGWebViewController.m
//  PampersRewards
//
//  Created by Dipen Sekhsaria on 18/11/15.
//  Copyright © 2015 ProcterAndGamble. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webViewURL,webViewTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = webViewTitle;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentWebView.delegate = self;
    
    [self loadWebView:self.contentWebView withURLString:webViewURL andPostDictionaryOrNil:nil/*[NSDictionary dictionaryWithObject:@"key" forKey:@"vale"]*/];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Load Webview URL

- (void) loadWebView:(UIWebView *)theWebView withURLString:(NSString *)urlString andPostDictionaryOrNil:(NSDictionary *)postDictionary {
    NSURL *url                          = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request        = [NSMutableURLRequest requestWithURL:url
                                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                              timeoutInterval:6000.0];
    
    
    // DATA TO POST
    if(postDictionary) {
        NSString *postString                = [self getFormDataString:postDictionary];
        NSData *postData                    = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength                = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }
    
    [theWebView loadRequest:request];
}



#pragma mark - Webview Delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    NSString *url = webView.request.URL.absoluteString;
//    NSString  *htmlContent = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
//    
//    NSLog(@"URL %@",url);
//    NSLog(@"HTML %@",htmlContent);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Webview content serializer

- (NSString *)getFormDataString:(NSDictionary*)dictionary {
    if( ! dictionary) {
        return nil;
    }
    NSArray* keys                               = [dictionary allKeys];
    NSMutableString* resultString               = [[NSMutableString alloc] init];
    for (int i = 0; i < [keys count]; i++)  {
        NSString *key                           = [NSString stringWithFormat:@"%@", [keys objectAtIndex: i]];
        NSString *value                         = [NSString stringWithFormat:@"%@", [dictionary valueForKey: [keys objectAtIndex: i]]];
        
        NSString *encodedKey                    = [self escapeString:key];
        NSString *encodedValue                  = [self escapeString:value];
        
        NSString *kvPair                        = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        if(i > 0) {
            [resultString appendString:@"&"];
        }
        [resultString appendString:kvPair];
    }
    return resultString;
}

- (NSString *)escapeString:(NSString *)string {
    if(string == nil || [string isEqualToString:@""]) {
        return @"";
    }
    NSString *outString     = [NSString stringWithString:string];
    outString                   = [outString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // BUG IN stringByAddingPercentEscapesUsingEncoding
    // WE NEED TO DO several OURSELVES
    outString                   = [self replace:outString lookFor:@"&" replaceWith:@"%26"];
    outString                   = [self replace:outString lookFor:@"?" replaceWith:@"%3F"];
    outString                   = [self replace:outString lookFor:@"=" replaceWith:@"%3D"];
    outString                   = [self replace:outString lookFor:@"+" replaceWith:@"%2B"];
    outString                   = [self replace:outString lookFor:@";" replaceWith:@"%3B"];
    
    return outString;
}

- (NSString *)replace:(NSString *)originalString lookFor:(NSString *)find replaceWith:(NSString *)replaceWith {
    if ( ! originalString || ! find) {
        return originalString;
    }
    
    if( ! replaceWith) {
        replaceWith                 = @"";
    }
    
    NSMutableString *mstring        = [NSMutableString stringWithString:originalString];
    NSRange wholeShebang            = NSMakeRange(0, [originalString length]);
    
    [mstring replaceOccurrencesOfString: find
                             withString: replaceWith
                                options: 0
                                  range: wholeShebang];
    
    return [NSString stringWithString: mstring];
}


#pragma mark - Action

- (IBAction)closeButtonTapped:(id)sender {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
