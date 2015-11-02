//
//  MasterViewController.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "SongTableViewCell.h"

#import "AppStyle.h"

#import "iTunesService.h"
#import "ImageService.h"

#import "Song.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray<Song *> *searchResults;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation MasterViewController

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"iTunes Playlist", @"");
    
    [self _configureTableView];
}

#pragma mark - Segues

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Song *song = self.searchResults[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        controller.imageService = self.imageService;
        [controller setSong:song];
    }
}

#pragma mark - UITableViewDataSource

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:[SongTableViewCell reuseIdentifier] forIndexPath:indexPath];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongTableViewCell *songCell = (SongTableViewCell *)cell;
    
    Song *song = self.searchResults[indexPath.row];
    songCell.artistName.text = song.artistName;
    songCell.trackName.text  = song.trackName;
    
    [self.imageService fetchImageWithURL:song.imageURL
                       completionHandler:^(UIImage *image, BOOL fromCache) {
                           if(fromCache) songCell.coverImage.image = image;
                           else {
                               songCell.coverImage.alpha = 0.0f;
                               songCell.coverImage.image = image;
                               [UIView animateWithDuration:0.3 animations:^{
                                   songCell.coverImage.alpha = 1.0f;
                               }];
                           }
                       }
                            errorHandler:^(NSError *error) {}];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= self.searchResults.count) return;
    
    Song *song = self.searchResults[indexPath.row];
    [self.imageService cancelImageWithURL:song.imageURL];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
}

#pragma mark - UISearchBarDelegate

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    __weak typeof(self) weakSelf = self;    
    [self.itunesService fetchPlaylistUsingSearchTerm:searchBar.text
                                   CompletionHandler:^(NSArray <Song *> * result) {
                                            [weakSelf.imageService cancelAllImageDownloads];
                                            [weakSelf.tableView setContentOffset:CGPointZero animated:NO];
                                            weakSelf.searchResults = result;
                                            [weakSelf.tableView reloadData];
    }
                                        errorHandler:^(NSError *error) {}];
    [searchBar resignFirstResponder];
}

#pragma mark - Private Functions

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)_configureTableView
{
    [self.tableView registerNib:[SongTableViewCell nib] forCellReuseIdentifier:[SongTableViewCell reuseIdentifier]];
    [self.tableView setRowHeight:150.0f];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:[AppStyle purple]];
}

@end
