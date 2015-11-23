//
//  CustomView.h
//  实验抽屉
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
{
    CGPoint openPointCenter;
    CGPoint closePointCenter;
}
-(id)initWithView:(UIView*)contentview parentView:(UIView*) parentview;

@property (nonatomic, strong) UIView *parentView; //抽屉视图的父视图
@property (nonatomic, strong) UIView *contenView; //抽屉显示内容的视图


@end
