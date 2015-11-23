//
//  DetailViewController.m
//  BestNews
//
//  Created by lanou3g on 15/11/20.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import "DetailViewController.h"

#import "FirstNews.h"
#import "DetailModel.h"
#import "CollectionController.h"


@interface DetailViewController ()<UIWebViewDelegate>
- (IBAction)back:(UIBarButtonItem *)sender;

// 存放数据的数组
@property(nonatomic,retain)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIWebView *webControl;
//最外层大字典
@property (nonatomic , retain) NSMutableDictionary *dic;
- (IBAction)collectionMyFavorite:(UIBarButtonItem *)sender;


@property(nonatomic,retain)NSMutableArray *titleArray;

- (IBAction)myFavorite:(UIButton *)sender;


//数据库
@property(nonatomic,retain)NSString *titlestr;
@property(nonatomic,strong)FMDatabase *db;

@property(nonatomic,retain)NSString *listTitle;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webControl.delegate = self;
    
    //解析webview
    [self parse];
    
    [self parseTitle];
    
    //解析title
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.webControl addGestureRecognizer:swip];
    //1.数据库路径
    NSString *doucument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [doucument stringByAppendingString:@"/collection.sqlite"];
    NSLog(@"%@",doucument);
    
    //2.创建数据库
    
    self.db = [FMDatabase databaseWithPath:path];
    
    //3.打开数据库
    if ([self.db open]) {
        NSLog(@"数据库打开成功");
        BOOL result = [self.db executeUpdate:@"create table collection (title text);"];
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }else{
        NSLog(@"打开数据库失败");
    }
    
    
 

    
    

}




//解析
-(void)parse{
//    NSLog(@"====%ld",_ID);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%ld",(long)self.ID]];
//    NSLog(@"%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof (self) temp = self;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            self.dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            NSLog(@"%@",_dic);
            
            
        }
        NSURL *shareURL= [NSURL URLWithString:_dic[@"share_url"]] ;
//        NSLog(@"%@",shareURL);
        NSURLRequest *shareRequest = [NSURLRequest requestWithURL:shareURL];
        
        [self.webControl loadRequest:shareRequest];
        
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [temp.webControl reload];
        });
        
        
        
    }];
    
    
    
    [task resume];
    
   
}
-(void)parseTitle{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // 开辟空间
        __weak typeof(self)temp =self;
        
        NSString *str = [kClassDetailListUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.ID] ];
        [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            self.titleArray = responseObject[@"title"];
            
//            NSLog(@"----------------%@",self.titleArray);
            dispatch_async(dispatch_get_main_queue(), ^{
             [temp.webControl reload];
                
            });
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
        
    });
}

//轻划返回
-(void)swip:(UISwipeGestureRecognizer *)sender{
    [self backLastPage];
}



// 去掉上面的广告
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('header-for-mobile')[0].style.display = 'none'"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(UIBarButtonItem *)sender {
    [self backLastPage];
}

-(void)backLastPage{
    [self dismissViewControllerAnimated:YES completion:nil];
}





//收藏
- (IBAction)collectionMyFavorite:(UIBarButtonItem *)sender {
    
    self.titlestr = [NSString stringWithFormat:@"%@",self.titleArray];
    [self.db executeUpdate:@"insert into collection (title) values (?);",self.titlestr];
    
    
}


- (IBAction)myFavorite:(UIButton *)sender {
    
    CollectionController *cllectionVC = [[CollectionController alloc]initWithStyle:UITableViewStylePlain];
    
    FMResultSet *rb = [self.db executeQuery:@"select *from collection;"];
    while ([rb next ]) {
        
        self.listTitle = [rb stringForColumn:@"title"];

        
        
        
        

    }
    
        [self presentViewController:cllectionVC animated:YES completion:nil];
   
    
}
@end
