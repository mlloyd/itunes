//
//  ImageService.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ImageServiceCompletionHandler)(UIImage *image, BOOL fromCache);
typedef void (^ImageServiceErrorHandler)(NSError *error);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol ImageService <NSObject>

- (void)fetchImageWithURL:(NSURL *)imageURL
        completionHandler:(ImageServiceCompletionHandler)completionHandler
             errorHandler:(ImageServiceErrorHandler)errorHandler;

- (void)cancelImageWithURL:(NSURL *)imageURL;
- (void)cancelAllImageDownloads;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface ImageService : NSObject<ImageService>

@end
