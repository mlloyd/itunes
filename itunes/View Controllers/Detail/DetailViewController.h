//
//  DetailViewController.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@protocol ImageService;
@class Song;
@interface DetailViewController : UIViewController

@property (nonatomic, weak) id<ImageService> imageService;

@property (nonatomic) Song *song;

@end

