//
//  DataHandle.h
//  A阶段项目程序
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 liyuerong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpdataUI)();
@interface DataHandle : NSObject

// 主题新闻
@property(nonatomic,strong) NSArray *array;

@property(nonatomic,strong) NSArray *Array;

@property (nonatomic,copy) UpdataUI myUpdataUI;

// 滑动新闻
@property(nonatomic,strong) NSArray *topNewsArray;

@property (nonatomic,strong) NSMutableDictionary *dataDictionary; // 分区字典

@property (nonatomic,strong) NSMutableArray *sectionArray;  // 分区时间
+ (DataHandle *) sharedHandle ;


@end
