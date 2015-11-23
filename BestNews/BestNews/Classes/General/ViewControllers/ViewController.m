//
//  ViewController.m
//  BestNews
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "FirstNews.h"
#import "NewsCell.h"
#import "Scroll.h"
#import "ClassTableViewController.h"

#import "Scroll.h"
#import "DetailViewController.h"

#import "DataHandle.h"




@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//存放tableview视图
@property(nonatomic,retain)UIView *contentView;
@property(nonatomic,retain)UITableView *tableView;


//轮播图
@property(nonatomic,retain)NSMutableArray *scrollArr;
@property(nonatomic,retain) UIView * contextView;
@property(nonatomic,retain)UIScrollView *scorllView;
@property(nonatomic,retain)UIPageControl *page;
@property(nonatomic,retain)UIImageView * imgView;
@property(nonatomic,retain)NSTimer *time;

@property(nonatomic,retain)NSMutableDictionary *dataDic;


//
@property(nonatomic,retain)ClassTableViewController *classVC;





@end

static NSString *identfier = @"cellReuse";
@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"hello新闻";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(classAction:)];
        
    }
    return self;
}
-(void)classAction:(UIBarButtonItem *)sender{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //抽屉视图
    self.classVC = [[ClassTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    self.classVC.view.frame = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view addSubview:self.classVC.view];
    CGRect rect = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height);
    UIView *contentView = [[UIView alloc] initWithFrame:rect];
    contentView.backgroundColor = [UIColor greenColor];
    CustomView *customView = [[CustomView alloc] initWithView:contentView
    parentView:self.view];

    [[customView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[customView layer] setShadowRadius:20];
    [[customView layer] setShadowOpacity:1];
    [[customView layer] setShadowColor:[UIColor blackColor].CGColor];
    [self.view addSubview:customView];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [contentView addSubview:_tableView];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:identfier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [DataHandle sharedHandle].myUpdataUI = ^(){
        [self.tableView reloadData];
        [self scrollParse];
    };
    
    
    //刷新
    [self refresh];


    
    
    


    
    
    

    
}




#pragma mark -- 轮播图
-(void)scrollParse{


    self.contextView =[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.contextView.frame.size.height)];
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/1.7 , self.scorllView.frame.size.height-30, self.view.frame.size.width/2, 20)];
    _scorllView.contentSize = CGSizeMake(self.view.frame.size.width*5, self.contentView.frame.size.height);
    _scorllView.delegate = self;
    _scorllView.pagingEnabled = YES;
    [self.contextView addSubview:self.scorllView];
    [self.contextView addSubview:_page];

    _page.currentPageIndicatorTintColor = [UIColor blackColor];
    _page.numberOfPages = 5;
    _page.currentPage = 0;
    _page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_page addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    
    
    
    self.tableView.tableHeaderView = self.contextView;

    
    
    for (int i = 0; i < [DataHandle sharedHandle].topNewsArray.count; i ++) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 64, self.view.frame.size.width, self.scorllView.frame.size.height)];
        
        Scroll *goods = [DataHandle sharedHandle].topNewsArray[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:goods.image]];
        
        imgView.backgroundColor = [UIColor yellowColor];
        
        [_scorllView addSubview:imgView];
        
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10 +i *self.view.frame.size.width, self.scorllView.frame.size.height-100, self.view.frame.size.width/2, self.contextView.frame.size.height/3)];
        lable.text = goods.title;
        lable.numberOfLines = 0;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont boldSystemFontOfSize:13.0];
        
        [self.scorllView addSubview:lable];
        
    }

    // 轮播图
    _time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
    [_time fire];

}




#pragma mark -- 时间戳和轮播图切换两个
- (void)timeAction
{
    static int i = 0;
    i ++;
    if (i > 4) {
        i = 0;
    }
    [self.scorllView setContentOffset:CGPointMake(self.view.frame.size.width*i, 0)];
    _page.currentPage = i;
    
}

//- (void)pageAction:(UIPageControl *)sender
//{
//    NSInteger index = sender.currentPage;
//    _scorllView.contentOffset = CGPointMake(self.view.frame.size.width*index, 0);
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
//    _page.currentPage = index;
//}



-(void)refresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置header
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

//下拉刷新
-(void)loadNewData{
    [self.tableView.mj_header endRefreshing];
}
//上拉加载
-(void)loadMoreData{
    [self.tableView.mj_footer endRefreshing];
    
    
    
    
}






-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSLog(@"---------%ld",[DataManager sharedManager].sectionArray.count);
//    return [DataManager sharedManager].sectionArray.count;
      return [DataHandle sharedHandle].sectionArray.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    NSArray *array = [DataManager sharedManager].dataDic[[DataManager sharedManager].sectionArray[section]];
//    
//    return array.count;
    
    NSArray *array = [DataHandle sharedHandle].dataDictionary[[DataHandle sharedHandle].sectionArray[section]];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier forIndexPath:indexPath];
    
//    NSArray *array = [DataManager sharedManager].dataDic[[DataManager sharedManager].sectionArray[indexPath.section]];
//    FirstNews *news = array[indexPath.row];
    
    NSArray *array =[DataHandle sharedHandle].dataDictionary[[DataHandle sharedHandle].sectionArray[indexPath.section]];
    
    FirstNews *news = array[indexPath.row];
    cell.firstNews = news;

    return cell;

}





//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    FirstNews *news = [[DataManager sharedManager]firstNewsWithIndex:indexPath.row];
    
    return 70;
}
//计算字符串的frame
-(CGFloat)textHeight:(NSString *)string{
    //17.系统默认字体
    CGRect  rect =  [string boundingRectWithSize:CGSizeMake(365, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    //返回计算好的高度
    return rect.size.height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [DataManager sharedManager].sectionArray[section];
    return [DataHandle sharedHandle].sectionArray[section];

}

#pragma mark -- 点击跳转

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    NSArray *array =[DataHandle sharedHandle].dataDictionary[[DataHandle sharedHandle].sectionArray[indexPath.section]];
    
    FirstNews *news = array[indexPath.row];
    detailVC.ID = news.id;
    [self presentViewController:detailVC animated:YES completion:nil];
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
