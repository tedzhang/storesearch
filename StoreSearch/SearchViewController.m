//
//  SearchViewController.m
//  StoreSearch
//
//  Created by ted zhang on 14-2-26.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultCell.h"
#import "SearchResult.h"
#import  <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>


@end

@implementation SearchViewController
{
    NSMutableArray *_searchResults;
    BOOL            _isLoading;
    NSOperationQueue *_queue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    UINib *cellNib = [UINib nibWithNibName:@"SearchResultCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"SearchResultCell"];
    self.tableView.rowHeight = 80;
    [self.searchBar becomeFirstResponder];
    
    
    cellNib = [UINib nibWithNibName:@"LoadingCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"LoadingCell"];
    
    cellNib = [UINib nibWithNibName:@"NotFoundCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"NotFoundCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isLoading)
        return 1;
    if (_searchResults == nil)
        return 0;
    if ([_searchResults count] == 1)
        return 1;
    return [_searchResults count] + 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isLoading)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView*)[cell viewWithTag:100];
        [spinner startAnimating];
        return cell;
    }
    else if ([_searchResults count] == 0)
    {
        return [tableView dequeueReusableCellWithIdentifier:@"NotFoundCell" forIndexPath:indexPath];
    }
    else
    {
        
        static NSString *cellIdentifer = @"SearchResultCell";
        SearchResultCell *cell = (SearchResultCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];

        SearchResult *searchResult = _searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.artistNameLabel.text = searchResult.artistName;
        [cell.imageView setImageWithURL:[NSURL URLWithString:searchResult.artworkUrl] placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
        return cell;
    }
    return nil;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_searchResults count] == 0 || _isLoading)
    {
        return nil;
    }
    return indexPath;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"the search text is %@",searchBar.text);
    
    if ([_searchBar.text length] == 0)
    {
        return;
    }
    
    if ([_searchBar.text length] > 0)
    {
        [searchBar resignFirstResponder];
        
        [_queue cancelAllOperations];
        _isLoading  = YES;
        [self.tableView reloadData];
        
        [self doSearch:searchBar.text];
        _isLoading  = NO;
        [self.tableView reloadData];
    }
    
    
}

-(void)doSearch:(NSString*) query
{
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    
    NSString *escapedText = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url         = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@",escapedText];
    NSURL    *newUrl      = [NSURL URLWithString:url];
    NSURLRequest *request = [ NSURLRequest requestWithURL:newUrl];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success %@",responseObject);
        [self parseResponse:responseObject];
        _isLoading = NO;
        [self.tableView reloadData];
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation isCancelled])
        {
            return;
        }
        NSLog(@"Failed %@",error);
    } ];
    
    [_queue addOperation:operation];
    
    
    
}

-(UIBarPosition) positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTop;
}

-(void)parseResponse:(NSDictionary*)dictionary
{
    NSArray * array = dictionary[@"results"];
    if (array == nil)
    {
        NSLog(@"expected result");
        return;
    }
    
    for (NSDictionary * dict in array)
    {
        NSString * wrapperType = dict[@"wrapperType"];
        if ([wrapperType isEqualToString:@"track"])
        {
            SearchResult *result = [[SearchResult alloc] init];
            result.name = dict[@"trackName"];
            result.artistName = dict[@"artistName"];
            result.artworkUrl = dict[@"artworkUrl60"];
            [_searchResults addObject:result];
        }
    }
}



@end
