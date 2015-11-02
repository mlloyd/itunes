//
//  DetailViewController.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "DetailViewController.h"

#import "ImageService.h"
#import "AppStyle.h"

#import "Song.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *artwork;
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *relaseDate;

@property (nonatomic) AVPlayer *player;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation DetailViewController

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    self.trackName.textColor  = [AppStyle purple];
    self.artistName.textColor = [AppStyle purple];
    self.price.textColor      = [AppStyle purple];
    self.relaseDate.textColor = [AppStyle purple];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.player play];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player pause];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)configureView
{
    self.player = [AVPlayer playerWithURL:self.song.audioURL];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *relaseDate = [dateFormatter stringFromDate:self.song.releaseDate];

    self.trackName.text  = [NSString stringWithFormat:@"Track: %@", self.song.trackName];
    self.artistName.text = [NSString stringWithFormat:@"Artist: %@", self.song.artistName];
    self.price.text      = [NSString stringWithFormat:@"Price: %@", [self.song.price stringValue]];
    self.relaseDate.text = [NSString stringWithFormat:@"Release date: %@", relaseDate];
    
    self.artwork.layer.cornerRadius = CGRectGetWidth(self.artwork.frame) / 2.0;
    
    [self.imageService fetchImageWithURL:self.song.imageURL
                       completionHandler:^(UIImage *image, BOOL fromCache) {
                           self.artwork.image = image;
                       }
                            errorHandler:nil];
}

@end
