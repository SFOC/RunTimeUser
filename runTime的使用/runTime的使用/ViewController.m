//
//  ViewController.m
//  runTime的使用
//
//  Created by fly on 2017/6/26.
//  Copyright © 2017年 flyfly. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h> //OC方法调用的本质就是发送消息,使用消息机制必须导入
#import "UIImage+ADDMeth.h"

@interface ViewController ()
@property (nonatomic, strong) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendMessage];
    [self exchangeMethod];
    [self addAttribute];
}

/*!
 1.发送消息
 
 消息机制的原理就是对象根据方法编号SEL去映射表查找对应的方法实现
 */

- (void)sendMessage {
    
    _person = [Person new];
    [_person eat];
    
    // 本质：让对象发送消息
    // 用类名调用类方法，底层会自动把类名转换成类对象调用
//    objc_msgSend([Person class], @selector(eat));
//    objc_msgSend(person, @selector(eat));
    
}


/*!
 2.交换方法
 
 作用是系统自带的方法功能如果不够,给系统自带的方法扩充一些功能,并保留原有的功能
 
 在分类中添加一个myImageWithName:方法,注意不能重写系统方法,因为会覆盖系统方法
 */
- (void)exchangeMethod {
    UIImage *img = [UIImage myImageWithName:@"test1"];
}

/*!
 3.动态添加方法
  
  作用：如果一个类有很多方法，那么类加载到内存比较耗费性能，需要给每一个
       方法生成映射表，可以使用动态给某个类，添加方法解决
 
 */


/*!
 4.给分类添加属性
 
   原理：给一个类声明属性，本质是给这个类添加关联，并不是直接把这个值的内存空间
        添加到类存空间
 */

// 定义关联的key
static const char *key = "name";
- (NSString *)name {
    // 根据关联的key，获取关联的值
    return objc_getAssociatedObject(self, key);
}

- (void)setName:(NSString *)name {
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数：关联的策略
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addAttribute {
    self.name = @"ddd";
    NSLog(@"给本类添加的属性是==%@",self.name);
}


/*!
 5.使用RunTime实现字典转模型
 
 
 */
/*!
 如何快速生成Plist文件属性名
 
 实现原理：通过便利字典，判断类型，拼接字符串
 */
- (void)quicklyGenerateFileAttributesWithDic:(NSDictionary *)dic {
    // 拼接属性字符串代码
    NSMutableString *strM = [NSMutableString string];
    
    // 1.遍历字典，把字典中所有key取出来，生成对应的属性代码
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *type;
        if ([obj isKindOfClass:[NSString class]]) {
            type = @"NSString";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            type = @"NSArray";
        }else if ([obj isKindOfClass:[NSNumber class]]){
            type = @"CGFloat";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            type = @"NSDictionary";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            type = @"BooL";
        }
        
        // 属性字符串
        NSString *str;
        if ([type containsString:@"NS"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type,key];
        }else{
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;",type,key];
        }
        
        // 每生成属性字符串，就自动换行
        [strM appendFormat:@"\n%@\n",str];
    }];
}

@end


















