//
//  ItunesRemoteService.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Song;

typedef void (^ItunesRemoteServiceCompletionHandler)(NSArray <Song *> * result);
typedef void (^ItunesRemoteServiceErrorHandler)(NSError *error);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol Location;
@protocol ItunesRemoteService <NSObject>

- (void)fetchPlaylistUsingSearchTerm:(NSString *)searchTerm
                   CompletionHandler:(ItunesRemoteServiceCompletionHandler)completionHandler
                        errorHandler:(ItunesRemoteServiceErrorHandler)errorHandler;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface ItunesRemoteService : NSObject<ItunesRemoteService>

@end
