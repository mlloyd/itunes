//
//  ItunesRemoteService.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import "ItunesRemoteService.h"

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
                        errorHandler:(ItunesRemoteServiceCompletionHandler)errorHandler;
{
    NSString *resource = [NSString stringWithFormat:@"%@%@", kItunesRemoteService_Endpoint, searchTerm];
    
    [self buildRequestWithResource:resource
                 completionHandler:completionHandler
                      errorHandler:errorHandler];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)buildRequestWithResource:(NSString *)resource
               completionHandler:(void (^)(NSArray *))completionHandler
                    errorHandler:(void (^)(NSError *))errorHandler
{
    NSString *encodedURL = [resource stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *serviceEndpoint = [NSURL URLWithString:encodedURL];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:serviceEndpoint
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     
                                                     if(data == nil ||
                                                        error!=nil ||
                                                        ((NSHTTPURLResponse *)response).statusCode != 200) {
                                                         NSError *responseError = [NSError errorWithDomain:@"com.itunes.remoteservice.search" code:-100 userInfo:@{}];
                                                         dispatch_sync(dispatch_get_main_queue(), ^(){ errorHandler(responseError); });
                                                     }
                                                     
                                                     NSError *responseProcessingError = nil;
                                                     NSDictionary *decodedResponseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                         options:0
                                                                                                                           error:&responseProcessingError];
                                                     // Could build these out, into MTLModel objects.
//                                                     NSArray *venuesResponseData = decodedResponseData[@"response"][@"venues"];
//                                                     NSMutableArray *venues = [NSMutableArray array];
                                                     
//                                                     NSError *parseError = nil;
//                                                     for (NSDictionary *venueDict in venuesResponseData) {
//                                                         APIVenue *decodedResponse = [MTLJSONAdapter modelOfClass:[APIVenue class]
//                                                                                            fromJSONDictionary:venueDict
//                                                                                                         error:&parseError];
//                                                         [venues addObject:decodedResponse];
//                                                     }                                                     
                                                     
                                                     dispatch_sync(dispatch_get_main_queue(), ^(){
                                                         completionHandler(nil);
                                                     });
                                                 }];
    
    [task resume];
}

@end
