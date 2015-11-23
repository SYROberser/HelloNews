//
//  ListController.m
//  BestNews
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import "ListController.h"
#import "ListModel.h"
#import "ListTableViewCell.h"
#import "DetailViewController.h"
#import "ClassModel.h"

@interface ListController ()

@property(nonatomic,retain)NSMutableArray *listArray;



@end

static NSString *identfier = @"cellList";
static NSString *customIdentfier = @"cellReuse";
@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册系统cell
 
         [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identfier];

        [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:customIdentfier];
        self.tableView.separatorColor = [UIColor orangeColor];
        

    
    //解析数据
    [self stepData];
    
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];

    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    
    

}






-(void)swip:(UISwipeGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)stepData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        self.listArray = [NSMutableArray array];
        __weak typeof(self)temp =self;
        NSString *urlStr = [kUserListUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.ID]];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            for (NSDictionary *dic in responseObject[@"stories"]) {
                ListModel *list = [ListModel new];
                [list setValuesForKeysWithDictionary:dic];
                [self.listArray addObject:list];
            }
            NSLog(@"---------------%@",urlStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [temp.tableView reloadData];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListModel *list = _listArray[indexPath.row];
    
    if (list.images.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier forIndexPath:indexPath];
       
        cell.textLabel.text = list.title;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font  = [UIFont systemFontOfSize:14];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 

     
        return cell;

    }else if(list.images.count == 1){
         ListTableViewCell *Ccell = [tableView dequeueReusableCellWithIdentifier:customIdentfier forIndexPath:indexPath];
        Ccell.lab4Title.text = list.title;
        Ccell.lab4Title.numberOfLines = 0;
        [Ccell.img4Pic sd_setImageWithURL:[NSURL URLWithString:list.images[0]]];
         Ccell.selectionStyle = UITableViewCellSelectionStyleNone;


        
       return Ccell;
 
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    


     ListModel *list = _listArray[indexPath.row];
    
    if (list.images.count == 0) {
        NSString *title = list.title;
        return [self textHeight:title]+20;
    }else{
        NSString *string = list.images[0];
        
        return [self textHeight:string]+50;
    }
    

}

//计算字符串的frame
-(CGFloat)textHeight:(NSString *)string{
    //17.系统默认字体
    CGRect  rect =  [string boundingRectWithSize:CGSizeMake(365, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    //返回计算好的高度
    return rect.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    ListModel *classM = _listArray[indexPath.row];
    detailVC.ID = classM.id;
    [self presentViewController:detailVC animated:YES completion:Nil];
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
