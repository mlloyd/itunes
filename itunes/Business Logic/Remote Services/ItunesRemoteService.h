//
//  ItunesRemoteService.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ItunesRemoteServiceCompletionHandler)(id result);
typedef void (^ItunesRemoteServiceErrorHandler)(NSError *error);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol Location;
@protocol ItunesRemoteService <NSObject>

- (void)fetchPlaylistUsingSearchTerm:(NSString *)searchTerm
                   CompletionHandler:(ItunesRemoteServiceCompletionHandler)completionHandler
                        errorHandler:(ItunesRemoteServiceCompletionHandler)errorHandler;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface ItunesRemoteService : NSObject<ItunesRemoteService>

@end
