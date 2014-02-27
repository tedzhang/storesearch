//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by ted zhang on 14-2-26.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;


@end
