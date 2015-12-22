//
//  DataSyncManager.m
//  HappPost
//
//  Created by Dipen Sekhsaria on 15/11/15.
//  Copyright (c) 2015 Star Deep. All rights reserved.
//

#import "DataSyncManager.h"
#import "RegisterResponseObject.h"
#import "NewsContentResponseObject.h"

@implementation DataSyncManager
@synthesize delegate,serviceKey;


-(void)startGETWebServicesWithBaseURL
{
    
    NSURL* url;
    url = [NSURL URLWithString:BaseWebServiceURL];

    
    NSLog(@"Service URl::%@/%@",url,self.serviceKey);
    //NSError *theError = nil;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    
    [manager GET:self.serviceKey parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObject valueForKey:statusKey] isEqualToString:@"Success"]) {
                [delegate didFinishServiceWithSuccess:[self prepareResponseObjectForServiceKey:self.serviceKey withData:responseObject] andServiceKey:self.serviceKey];
            }
            else {
                [delegate didFinishServiceWithFailure:[responseObject valueForKey:@"Message"]];
            }
            
            
        }
        else {
            [delegate didFinishServiceWithFailure:@"Unexpected network error"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [delegate didFinishServiceWithFailure:@"Please check your internet connection and try again later."];
       
    }];
    
}


-(void)startPOSTWebServicesWithParams:(NSMutableDictionary *)postData
{
    
    NSURL* url;
    url = [NSURL URLWithString:BaseWebServiceURL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 300)];
    //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:self.serviceKey parameters:postData success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                if ([[responseObject valueForKey:statusKey] isEqualToString:@"Success"]) {
                    [delegate didFinishServiceWithSuccess:[self prepareResponseObjectForServiceKey:self.serviceKey withData:responseObject] andServiceKey:self.serviceKey];
                }
                else {
                    [delegate didFinishServiceWithFailure:[responseObject valueForKey:@"Message"]];
                }
                
                
            }
            else {
                [delegate didFinishServiceWithFailure:@"Unexpected network error"];
            }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"");
        [delegate didFinishServiceWithFailure:@"Please check your internet connection and try again later."];
        
    }];
    
}




- (id) prepareResponseObjectForServiceKey:(NSString *) responseServiceKey withData:(id)responseObj {
    
    if ([responseServiceKey isEqualToString:kRegisterService] || [responseServiceKey isEqualToString:kSkipRegistrationService]) {
        
        RegisterResponseObject* response = [[RegisterResponseObject alloc] initWithDictionary:responseObj];
        return response;
        
    }
    if ([responseServiceKey isEqualToString:kGetNewsContent] ) {
        
        NewsContentResponseObject* response = [[NewsContentResponseObject alloc] initWithDictionary:responseObj];
        [[SharedClass sharedInstance] insertNewsContentResponseIntoDB:response];
        [delegate didUpdateLatestNewsContent];
        
    }
    if ([responseServiceKey isEqualToString:kVerifyService] ) {
        
        return [[NSDictionary alloc] init];
        
    }
    if ([responseServiceKey isEqualToString:kGetMasterGenreList] ) {
        
        [[DBManager sharedManager] insertEntryIntoMasterGenresTableWithGenreArr:[responseObj valueForKey:ListOfAllGenresKey]];
        return [[NSDictionary alloc] init];
        
    }
    
    return nil;
    
}

@end
