//
//  ClassTableViewController.m
//  BestNews
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import "ClassTableViewController.h"
#import "ClassModel.h"
#import "ViewController.h"
#import "ListController.h"
#import "CollectionController.h"


@interface ClassTableViewController ()

//功能视图
@property(nonatomic,strong)UIView *functionView;

//存放数据数组
@property(nonatomic,retain)NSMutableArray *classArray;

//
@property(nonatomic,retain)UIView *bossView;





@end

static NSString *identfier = @"cellClass";
@implementation ClassTableViewController


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identfier];
    
    //加载
    [self parsse];
    
    [self signUI];
    



}
-(void)backFirstNews:(UIButton *)sender{
    
    ViewController *vC = [[ViewController alloc]init];
    
    [self presentViewController:vC animated:YES completion:nil];
}

//解析数据
-(void)parsse{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    self.classArray = [NSMutableArray array];
    __weak typeof(self)temp =self;
    [manager GET:kClassListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);

        for (NSDictionary *dic in responseObject[@"others"]) {
            ClassModel *cModel = [ClassModel new];
            [cModel setValuesForKeysWithDictionary:dic];
            [self.classArray addObject:cModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];

}

-(void)signUI{
    self.functionView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width *0.6, (self.view.frame.size.height-20)/3)];
    self.functionView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.functionView;
    self.tableView.separatorColor = [UIColor whiteColor];

    
    for (int i = 0; i < 3; i ++) {
        if (i == 0) {
            UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"us.png"]];
            imgV.frame = CGRectMake(10, 74*(i+1), 40, 40);
            imgV.layer.masksToBounds = YES;
            imgV.layer.cornerRadius = 20;
            [self.functionView addSubview:imgV];
            
            UILabel *nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame), CGRectGetMinY(imgV.frame), self.view.frame.size.width/3, 40)];
            //            nameLabel.backgroundColor = [UIColor redColor];
            [self.functionView addSubview:nameLabel];
            
        }else if (i == 1){
            UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
            collectionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            collectionBtn.frame = CGRectMake(15, 60*(i+1), 70, 40);
            [self.functionView addSubview:collectionBtn];
            [collectionBtn addTarget:self action:@selector(myCollection:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [firstBtn setTitle:@"首页" forState:UIControlStateNormal];
            firstBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            
            firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            firstBtn.frame = CGRectMake(14, 60*(i+1), 70, 40);
            firstBtn.tintColor = [UIColor blackColor];
            
            [self.functionView addSubview:firstBtn];
            [firstBtn addTarget:self action:@selector(backFirstNews:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    
}

//收藏

#pragma mark --------------------------
-(void)myCollection:(UIButton *)sender{
    CollectionController *collectionVC = [[CollectionController alloc]init];
  

    
    [self presentViewController:collectionVC animated:YES completion:nil];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.classArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    ClassModel *classM = self.classArray[indexPath.row];
    cell.textLabel.text = classM.name;
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListController *listVC = [[ListController alloc]init];
    ClassModel *cm = self.classArray[indexPath.row];
    listVC.ID = cm.id;
    [self presentViewController:listVC animated:YES completion:^{

    }];
 

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
