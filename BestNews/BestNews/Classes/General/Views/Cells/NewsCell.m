//
//  NewsCell.m
//  BestNews
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell



-(void)setFirstNews:(FirstNews *)firstNews{
    _firstNews = firstNews;
    _lab4Title.text = firstNews.title;
    [_img4Pic  sd_setImageWithURL:[NSURL URLWithString:firstNews.images[0]]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
