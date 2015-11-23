//
//  CustomView.m
//  实验抽屉
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
#define OPENCENTERX 120
#define DIVIDWIDTH 70.0 //OPENCENTERX 对应确认是否打开或关闭的分界线。



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithView:(UIView *)contentview parentView:(UIView *)parentview
{
    self = [super initWithFrame:CGRectMake(0,0,contentview.frame.size.width, contentview.frame.size.height)];
    if (self) {
//        self.contenView.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        self.contenView = contentview;
        self.parentView = parentview;
        
        [self addSubview:contentview];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        

        [self addGestureRecognizer:panGestureRecognizer];
        
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//        
//        
//        [self addGestureRecognizer:tapGestureRecognizer];
        openPointCenter = CGPointMake(self.parentView.center.x + OPENCENTERX,
                                      self.parentView.center.y);
//        
//        NSLog(@"openPointCenter x:%f, openPointCenter y:%f",
//              openPointCenter.x,
//              openPointCenter.y);
    }
    return self;
}

-(void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.parentView];
    
    float x = self.center.x + translation.x/2;
    NSLog(@"translation x:%f", translation.x);
    NSLog(@"-------------%f",self.center.x);
    
    if (x < self.parentView.center.x) {
        x = self.parentView.center.x;
    }
    self.center = CGPointMake(x, openPointCenter.y);
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.45
                              delay:0.01
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void)
         {
             if (x > openPointCenter.x - DIVIDWIDTH) {
            
                     self.center = openPointCenter;
                 
                CGPoint de = [recognizer translationInView:self.parentView];
                 self.parentView.transform = CGAffineTransformTranslate(self.parentView.transform, de.x, de.y);
              
             }else{
                 self.center = CGPointMake(openPointCenter.x - OPENCENTERX,
                                           openPointCenter.y);
             }
         }completion:^(BOOL isFinish){
//             self.center = CGPointMake(self.frame.size.width/2+150, self.frame.size.height/2);
         }];
    }
    
    
    [recognizer setTranslation:CGPointZero inView:self.parentView];
}

//-(void) handleTap:(UITapGestureRecognizer*) recognizer
//{
//    [UIView animateWithDuration:0.75
//                          delay:0.01
//                        options:UIViewAnimationTransitionCurlUp animations:^(void){
//                            self.center = CGPointMake(openPointCenter.x - OPENCENTERX,
//                                                      openPointCenter.y);
//                        }completion:nil];
//}
@end
