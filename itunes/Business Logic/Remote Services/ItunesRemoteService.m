//
//  ItunesRemoteService.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import "ItunesRemoteService.h"
#import "Song.h"

/*//////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

 - where SEARCHTERMn is a string that the user can enter in a search box, text field or similar (your choice)
that is visible somewhere in the master view. For example entering "Jack Johnson" in the search box would yield
an end point of http://itunes.apple.com/search?term=Jack+Johnson
 
*///////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
NSString *const kItunesRemoteService_Endpoint = @"http://itunes.apple.com/search?term=";

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface ItunesRemoteService ()

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDataTask *task;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation ItunesRemoteService

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (instancetype)init
{
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)fetchPlaylistUsingSearchTerm:(NSString *)searchTerm
                   CompletionHandler:(ItunesRemoteServiceCompletionHandler)completionHandler
                        errorHandler:(ItunesRemoteServiceErrorHandler)errorHandler;
{
    NSString *resource = [NSString stringWithFormat:@"%@%@", kItunesRemoteService_Endpoint, searchTerm];
    
    [self buildRequestWithResource:resource
                 completionHandler:completionHandler
                      errorHandler:errorHandler];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)buildRequestWithResource:(NSString *)resource
               completionHandler:(ItunesRemoteServiceCompletionHandler)completionHandler
                    errorHandler:(ItunesRemoteServiceErrorHandler)errorHandler
{
    [self.task cancel];
    
    NSString *encodedURL = [resource stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *serviceEndpoint = [NSURL URLWithString:encodedURL];
    
    self.task = [self.session dataTaskWithURL:serviceEndpoint
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 if(data == nil || error || ((NSHTTPURLResponse *)response).statusCode != 200) {
                                     NSError *responseError = [NSError errorWithDomain:@"com.itunes.remoteservice.search" code:-100 userInfo:@{}];
                                     dispatch_sync(dispatch_get_main_queue(), ^(){ errorHandler(responseError); });
                                     return;
                                 }
                                 
                                 NSError *responseProcessingError = nil;
                                 NSDictionary *decodedResponseData = [NSJSONSerialization JSONObjectWithData:data options:0
                                                                                                       error:&responseProcessingError];
                                
                                if(responseProcessingError != nil) {
                                     dispatch_sync(dispatch_get_main_queue(), ^(){ errorHandler(responseProcessingError); });
                                }
                                
                                 NSArray *resultsJSON = decodedResponseData[@"results"];
                                 NSMutableArray *results = [NSMutableArray array];
                                 
                                 for (NSDictionary *songDictionary in resultsJSON) @autoreleasepool {
                                     Song *song = [[Song alloc] initWithDictionary:songDictionary];
                                     [results addObject:song];
                                 }
                                 
                                 dispatch_sync(dispatch_get_main_queue(), ^(){
                                     completionHandler(results);
                                 });
                             }];
    [self.task resume];    
}

@end
