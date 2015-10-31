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

#import "iTunesService.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic) NSMutableArray *searchResults;

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
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self _configureTableView];
    [self _createActivityIndicator];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
//    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.searchResults[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        [controller setDetailItem:[NSNull null]];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SongTableViewCell reuseIdentifier] forIndexPath:indexPath];

    id result = self.searchResults[indexPath.row];
    cell.textLabel.text = [result description];
    return cell;
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
    
    [self.activityIndicatorView startAnimating];
    [searchBar resignFirstResponder];
    // TODO: Validate search bar text
    self.view.userInteractionEnabled = NO;
    
    dispatch_block_t fetchCompletionHandler = ^(){
        weakSelf.view.userInteractionEnabled = YES;
        [weakSelf.activityIndicatorView stopAnimating];
    };
    
    dispatch_block_t completionHandler = ^(){
        [self.itunesService fetchPlaylistUsingSearchTerm:searchBar.text
                                       CompletionHandler:^(id result) {
                                                [weakSelf.tableView reloadData];
                                                [weakSelf animateOverlayToAlpha:0.0 completionHandler:fetchCompletionHandler];
    }
                                            errorHandler:^(id result) {
                                                  [weakSelf animateOverlayToAlpha:0.0 completionHandler:fetchCompletionHandler];
                                            }];
    };
    
    [self animateOverlayToAlpha:0.6 completionHandler:completionHandler];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)animateOverlayToAlpha:(CGFloat)alpha completionHandler:(dispatch_block_t)completionHandler
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
//                         weakSelf.overlay.alpha = alpha;
                     }
                     completion:^(BOOL finished) {
                         completionHandler();
                     }];
}

#pragma mark - Private Functions

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)_configureTableView
{
    [self.tableView registerNib:[SongTableViewCell nib] forCellReuseIdentifier:[SongTableViewCell reuseIdentifier]];
    [self.tableView setRowHeight:80.0f];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)_createActivityIndicator
{
//    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    self.activityIndicatorView.hidesWhenStopped = YES;
//    [self.view addSubview:self.activityIndicatorView];
//    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//    }];
}

@end
