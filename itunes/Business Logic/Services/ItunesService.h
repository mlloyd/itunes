//
//  ItunesService.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Song;

typedef void (^ItunesServiceCompletionHandler)(NSArray <Song *> * result);
typedef void (^ItunesServiceErrorHandler)(NSError *error);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol Location;
@protocol ItunesService <NSObject>

- (void)fetchPlaylistUsingSearchTerm:(NSString *)searchTerm
                   CompletionHandler:(ItunesServiceCompletionHandler)completionHandler
                        errorHandler:(ItunesServiceErrorHandler)errorHandler;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol ItunesRemoteService;
@interface ItunesService : NSObject<ItunesService>

- (instancetype)initWithRemoteService:(id<ItunesRemoteService>)remoteService;

@end
