//
//  AppTutorialViewController.m
//  Happ Post
//
//  Created by Dipen Sekhsaria on 30/10/15.
//  Copyright © 2015 Stardeep. All rights reserved.
//

#import "AppTutorialPageViewController.h"
#import "AppTutorialFirstPageViewController.h"
#import "AppTutorialSecondPageViewController.h"
#import "AppTutorialThirdPageViewController.h"
#import "NewsContentResponseObject.h"
#import "NewsContentRequestObject.h"
#import "RegisterRequestObject.h"
#import "RegisterResponseObject.h"

@interface AppTutorialPageViewController ()

@end

@implementation AppTutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initializePageViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializePageViewController {
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppTutorialPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.previousButton.hidden = YES;
    
    [self movePageControllerToIndex:0 andAnimation:NO andDirection:0];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}


#pragma mark - News content handler

- (void)didTapDoneButton {
    
    [self startSkipRegistrationService];
    
}



- (void) startSkipRegistrationService {
    
    [SVProgressHUD showWithStatus:@"Preparing for first time use"];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kSkipRegistrationService;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForSkipregistration]];
    
}

-(void) startGetNewsContentService {
    
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetNewsContent;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:[self prepareDictionaryForNewsContent]];
    
}

-(void) startGetGenresContentService {
    
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetMasterGenreList;
    manager.delegate = self;
    [manager startGETWebServicesWithBaseURL];
    
}


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(RegisterResponseObject *)responseData andServiceKey:(NSString *)requestServiceKey {
    
    
    if ([requestServiceKey isEqualToString:kSkipRegistrationService]) {
        
        [[SharedClass sharedInstance] setUserId:responseData.userId];
        [[SharedClass sharedInstance] setUserRegisterDetails:registerObj];
        
        [[DBManager sharedManager] insertEntryIntoUserTableWithUserId:responseData.userId andOtherUserDetails:registerObj];
        
        [self startGetGenresContentService];
        
    }
    
    if ([requestServiceKey isEqualToString:kGetMasterGenreList]) {
        
        [self startGetNewsContentService];
        
    }
    
}


-(void) didFinishServiceWithFailure:(NSString *)errorMsg {
    
    [SVProgressHUD dismiss];
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Server error"
                                                  message:@"Request timed out, please try again later."
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles: nil];
    
    if (![errorMsg isEqualToString:@""]) {
        [alert setMessage:errorMsg];
    }
    
    [alert show];
    
    return;
    
}

-(void) didUpdateLatestNewsContent {
    
    [SVProgressHUD showSuccessWithStatus:@"News Updated"];
    [self performSegueWithIdentifier:@"showCardViewSegue" sender:nil];
    
}

#pragma mark - Modalobject

- (NSMutableDictionary *) prepareDictionaryForSkipregistration {
    
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
    if (!deviceToken) {
        deviceToken = @"111";
    }
    
    registerObj = [[RegisterRequestObject alloc] init];
    registerObj.email = @"";
    registerObj.name = @"";
    registerObj.deviceId = deviceToken;
    registerObj.deviceTypeId = iOSDeviceType;
    registerObj.gcmId = deviceToken;
    registerObj.ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return [registerObj createRequestDictionary];
    
}

- (NSMutableDictionary *) prepareDictionaryForNewsContent {
    
    NewsContentRequestObject* requestObj = [[NewsContentRequestObject alloc] init];
    requestObj.userId = [[SharedClass sharedInstance] userId];
    requestObj.timestamp = @"";
    
    return [requestObj createRequestDictionary];
    
}



#pragma mark - Page View Controller Helper

- (NSMutableArray *)viewControllerAtIndex:(NSUInteger)index
{
    if ((index >= 3)) {
        return nil;
    }
    
    NSMutableArray* pageContentArr = [[NSMutableArray alloc] init];
    
    if (index == 0) {
        
        // Create a new view controller and pass suitable data.
        AppTutorialFirstPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppTutorialFirstPageViewController"];
        pageContentViewController.pageIndex = index;
        [pageContentArr addObject:pageContentViewController];
        
    }
    else if (index == 1){
        
        // Create a new view controller and pass suitable data.
        AppTutorialSecondPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppTutorialSecondPageViewController"];
        pageContentViewController.pageIndex = index;
        [pageContentArr addObject:pageContentViewController];
        
    }
    else if (index == 2){
        
        // Create a new view controller and pass suitable data.
        AppTutorialThirdPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppTutorialThirdPageViewController"];
        pageContentViewController.delegate = self;
        pageContentViewController.pageIndex = index;
        [pageContentArr addObject:pageContentViewController];
        
    }
    else {
        return nil;
    }
    
    
    return pageContentArr;
}

- (void) movePageControllerToIndex:(int)index andAnimation:(BOOL)animation andDirection:(int)direction {
    
    if (index == 0) {
        AppTutorialFirstPageViewController *startingViewController = [[self viewControllerAtIndex:index] objectAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:direction animated:animation completion:nil];
    }
    else if (index == 1) {
        AppTutorialSecondPageViewController *startingViewController = [[self viewControllerAtIndex:index] objectAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:direction animated:animation completion:nil];
    }
    else if (index == 2) {
        AppTutorialThirdPageViewController *startingViewController = [[self viewControllerAtIndex:index] objectAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:direction animated:animation completion:nil];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((AppTutorialFirstPageViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [[self viewControllerAtIndex:index] objectAtIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((AppTutorialFirstPageViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == 3) {
        return nil;
    }
    return [[self viewControllerAtIndex:index] objectAtIndex:0];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return currentIndex;
}


#pragma mark - Page View Controller Delegate


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    
    movedToNewPage = true;
    
    if ([[pendingViewControllers objectAtIndex:0] isKindOfClass:[AppTutorialSecondPageViewController class]] ) {
        transitionToIndex = 1;
    }
    else if ([[pendingViewControllers objectAtIndex:0] isKindOfClass:[AppTutorialFirstPageViewController class]] ) {
        transitionToIndex = 0;
    }
    else if ([[pendingViewControllers objectAtIndex:0] isKindOfClass:[AppTutorialThirdPageViewController class]] ) {
        transitionToIndex = 2;
    }
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed && movedToNewPage) {
        
        currentIndex = transitionToIndex;
        [self refreshUIAfterPageChange];
        
    }
    
    movedToNewPage = false;
    
    
}

#pragma mark - Actions

- (IBAction)previousButtonTapped:(id)sender {
    
    currentIndex --;
    [self movePageControllerToIndex:currentIndex andAnimation:YES andDirection:1];
    [self refreshUIAfterPageChange];
    
}

- (IBAction)nextButtonTapped:(id)sender {
    
    if ([self.nextButton.titleLabel.text isEqualToString:NSLocalizedString(@"Next", nil)]) {
        currentIndex ++;
        [self movePageControllerToIndex:currentIndex andAnimation:YES andDirection:0];
        [self refreshUIAfterPageChange];
    }
    else {
        
        
        
    }
    
    
}


- (void) refreshUIAfterPageChange {
    
    if (currentIndex == 0) {
        
    }
    else if (currentIndex == 1) {
        
    }
    
    
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
