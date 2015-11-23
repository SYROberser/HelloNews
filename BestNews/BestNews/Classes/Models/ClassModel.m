//
//  ClassModel.m
//  BestNews
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 SOberser. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.Description = value;
       
    }
}


@end
