//
//  UIImage+ADDMeth.m
//  runTime的使用
//
//  Created by fly on 2017/6/26.
//  Copyright © 2017年 flyfly. All rights reserved.
//

#import "UIImage+ADDMeth.h"
#import <objc/runtime.h>

@implementation UIImage (ADDMeth)
+ (UIImage *)myImageWithName:(NSString *)name {
    UIImage *img = [UIImage imageNamed:name];
    if (img == nil) {
        NSLog(@"此image是空的");
    }else {
        NSLog(@"此image存在");
    }
    return img;
}

// 加载分类到内存的使用调用（就是当运行程序的使用就加载了此方法）
+ (void)load {
    NSLog(@"加载分类到内存的使用调用");
    // 获取imageWithName方法地址
    Method imageWithName = class_getClassMethod(self, @selector(myImageWithName:));
    
    // 获取myImageWithName方法地址
    Method myImageWithName = class_getClassMethod(self, @selector(myImageWithName:));
    
    // 交换方法地址，相当于交换实现方式
    method_exchangeImplementations(imageWithName, myImageWithName);
}
@end










