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

@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>


@end

@implementation SearchViewController
{
    NSMutableArray *_searchResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchResults == nil)
        return 0;
    return [_searchResults count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"SearchResultCell";
    
    SearchResultCell *cell = (SearchResultCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if ([_searchResults count] == 0)
    {
        cell.nameLabel.text = @"Nothing found";
        cell.artistNameLabel.text = @"";
    }
    else
    {
        SearchResult *searchResult = _searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.artistNameLabel.text = searchResult.artistName;
    }
    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_searchResults count] == 0)
    {
        return nil;
    }
    return indexPath;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"the search text is %@",searchBar.text);
}

-(UIBarPosition) positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTop;
}

@end
