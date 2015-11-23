//
//  NewsCell.h
//  BestNews
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstNews.h"

@interface NewsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lab4Title;
@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;

@property(nonatomic,retain)FirstNews *firstNews;
@end
