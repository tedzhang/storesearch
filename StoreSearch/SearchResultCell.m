//
//  SearchResultCell.m
//  StoreSearch
//
//  Created by ted zhang on 14-2-26.
//  Copyright (c) 2014年 ted zhang. All rights reserved.
//

#import "SearchResultCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.5f];
    
    self.selectedBackgroundView = selectedView;
    
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageView cancelImageRequestOperation];
    self.nameLabel.text = nil;
    self.artistNameLabel.text = nil;
    
}

@end
