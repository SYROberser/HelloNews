//
//  DataHandle.m
//  A阶段项目程序
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 liyuerong.com. All rights reserved.
//

#import "DataHandle.h"
#import "AFNetworking.h"
#import "FirstNews.h"
#import "Scroll.h"

@interface DataHandle ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *topArray;

@property (nonatomic,assign) NSInteger todayDate; // 今日日期

@property (nonatomic,strong) NSMutableArray *todayArray; // 今天新闻

@property (nonatomic,retain) NSMutableArray *oldArray; // 旧新闻

@end

static DataHandle *dataHandle = nil;
@implementation DataHandle

-(NSArray *)Array {
    return self.oldArray;
}
-(NSMutableArray *)dataArray {
    
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSArray *)array {
 return self.dataArray;
    
}
-(NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray =[NSMutableArray array];
    }
    return _sectionArray;
}

-(NSMutableArray *)topArray {
    if (!_topArray) {
        _topArray =[NSMutableArray array];
    }
    return _topArray;
}
-(NSArray *)topNewsArray {
    return self.topArray;
}

-(NSMutableDictionary *)dataDictionary {
    if (!_dataDictionary) {
        _dataDictionary =[NSMutableDictionary new];
    }
    return _dataDictionary;
}
-(NSMutableArray *)oldArray {
    if (!_oldArray) {
        _oldArray =[NSMutableArray array];
    }
    return _oldArray;
}

// 单例
+ (DataHandle *) sharedHandle {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataHandle =[[DataHandle alloc] init];
        
        [dataHandle parseData];
      
    });
  
    return dataHandle;
}

- (void)parseData {
    
 //  ---------------------解析今日数据------------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak typeof(self)temp =self ;
    
    [manager GET:kNewsListURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"请求成功");
    
        for (NSDictionary *dic in responseObject[@"stories"]) {
            
            FirstNews *news = [FirstNews new];
            
            [news setValuesForKeysWithDictionary:dic];
            
            [ temp.dataArray addObject:news];
            }
        
        // 分区时间
        temp.todayDate =[responseObject[@"date"] integerValue];
        
        [temp.sectionArray addObject:responseObject[@"date"]];
        
        // 添加到字典
        [temp.dataDictionary setObject:temp.dataArray forKey:responseObject[@"date"]];
        
        for (NSDictionary *dic in responseObject[@"top_stories"]) {
            Scroll *topNews =[Scroll new];
            
            [topNews setValuesForKeysWithDictionary:dic];
            
            [temp.topArray addObject:topNews];
        }
         NSLog(@"%@",[NSThread currentThread]);
              [self requestOldDate];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        
        
    }];
}


// ------------------解析往昔数据---------------

- (void)requestOldDate {
    for (int i = 0; i < 5; i++) { // 缓存
        __weak typeof(self)temp =self;
       
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld",kOldListURL,self.todayDate - i]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // tableView
            NSArray *array = dic[@"stories"];
            for (NSDictionary *dic in array) {
                FirstNews *latest = [FirstNews new];
                [latest setValuesForKeysWithDictionary:dic];
                [temp.oldArray addObject:latest];
            }
            // 分区
            [temp.sectionArray addObject:dic[@"date"]];
            
            // 排序
            // 1.系统默认升序
            NSComparator sortBlock = ^(id string1, id string2) {
                return [string1 compare:string2];
            };
            NSArray *sortArray1 = [self.sectionArray sortedArrayUsingComparator:sortBlock];
            // 2.强制降序
            NSArray *sortArray2 = [sortArray1 sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj2 compare:obj1];
            }];
            self.sectionArray = [NSMutableArray arrayWithArray:sortArray2];
            [self.dataDictionary setObject:_oldArray forKey:dic[@"date"]];
             NSLog(@"%@",[NSThread currentThread]);
            //刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                self.myUpdataUI();
            });
            
        }];
        [task resume];
    }

}






@end
