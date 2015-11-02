//
//  AppAssembly.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import "AppAssembly.h"

#import "ItunesRemoteService.h"
#import "ItunesService.h"
#import "ImageService.h"

#import "MasterViewController.h"
#import "DetailViewController.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface AppAssembly () <UINavigationControllerDelegate>

@property (nonatomic) UIWindow *window;

@property (nonatomic) id<ItunesRemoteService> itunesRemoteService;
@property (nonatomic) id<ItunesService      > itunesService;
@property (nonatomic) id<ImageService       > imageService;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation AppAssembly

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithWindow:(UIWindow *)window
{
    if (self = [super init]) {
        self.itunesRemoteService = [[ItunesRemoteService alloc] init];
        self.imageService        = [[ImageService alloc] init];
        self.itunesService       = [[ItunesService alloc] initWithRemoteService:self.itunesRemoteService];
        
        self.window = window;
        [self injectDependencies];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)injectDependencies
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *masterViewController   = (MasterViewController *)navigationController.topViewController;
    
    masterViewController.itunesService = [self fetchItunesService];
    masterViewController.imageService  = [self fetchImageService];    
}

#pragma mark - UINavigationControllerDelegate

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

@end
