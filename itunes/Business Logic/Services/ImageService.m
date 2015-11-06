//
//  ImageService.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import "ImageService.h"
#import "URLSessionOperation.h"

#define SafeBlockAsyncMainExec(block, ...) dispatch_async(dispatch_get_main_queue(), ^(){if(block) { block(__VA_ARGS__);};});

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface ImageService ()

@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) NSURLSession     *session;
@property (nonatomic) NSCache          *imageCache;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation ImageService

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (instancetype)init
{
    if (self = [super init]) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 3;
        
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
        
        self.imageCache = [[NSCache alloc] init];
        self.imageCache.countLimit = 100;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)fetchImageWithURL:(NSURL *)imageURL
        completionHandler:(ImageServiceCompletionHandler)completionHandler
             errorHandler:(ImageServiceErrorHandler)errorHandler
{
    NSString *key = [imageURL absoluteString];
    UIImage *image = [self.imageCache objectForKey:key];
    
    // Check cache
    if(image != nil) {
        completionHandler(image, YES);
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    // Download image
    URLSessionOperation *operation =
    [[URLSessionOperation alloc] initWithSession:self.session
                                             URL:imageURL
                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error || data==nil) {
            SafeBlockAsyncMainExec(errorHandler, error);
            return;
        }
        
        UIImage *image = [[UIImage alloc] initWithData:data];
        if(image) {
            [weakSelf.imageCache setObject:image forKey:key];
            SafeBlockAsyncMainExec(completionHandler, image, NO);
        }
        else {
            NSError *dataError = [NSError errorWithDomain:@"com.mlloyd.itunes.imageFetchFailed" code:-1 userInfo:nil];
            SafeBlockAsyncMainExec(errorHandler, dataError);
        }
    }];
    
    operation.name = key;
    [self.queue addOperation:operation];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)cancelImageWithURL:(NSURL *)imageURL
{
    NSString *key = [imageURL absoluteString];
    
    [self.queue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL found = [operation.name isEqualToString:key];
        
        if(found == YES) {
            [operation cancel];
            *stop = YES;
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)cancelAllImageDownloads
{
    [self.queue cancelAllOperations];
}

@end
