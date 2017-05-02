//
//  ViewController.h
//  相册练习
//
//  Created by 辛忠志 on 2017/5/2.
//  Copyright © 2017年 辛忠志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (cutImage)

//颜色转换成图片(带圆角的)
+ (UIImage *)imageWithColor:(UIColor *)color redius:(CGFloat)redius size:(CGSize)size;
//将图片截成圆形图片
+ (UIImage *)imagewithImage:(UIImage *)image;

@end
