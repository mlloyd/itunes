//
//  MasterViewController.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol ItunesService;
@protocol ImageService;
@interface MasterViewController : UIViewController

@property (nonatomic, weak) id<ItunesService> itunesService;
@property (nonatomic, weak) id<ImageService> imageService;

@end

