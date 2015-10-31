//
//  AppAssembly.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol ItunesService;
@protocol ImageService;
@protocol AppAssembly <NSObject>

- (id<ItunesService>)fetchItunesService;
- (id<ImageService >)fetchImageService;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface AppAssembly : NSObject<AppAssembly>

@property (nonatomic, readonly, getter=fetchItunesService) id<ItunesService> itunesService;
@property (nonatomic, readonly, getter=fetchImageService)  id<ImageService > imageService;

- (instancetype)initWithWindow:(UIWindow *)window;

@end
