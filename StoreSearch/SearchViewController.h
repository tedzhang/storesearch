//
//  SearchViewController.h
//  StoreSearch
//
//  Created by ted zhang on 14-2-26.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
