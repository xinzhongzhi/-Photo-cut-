//
//  ViewController.m
//  相册练习
//
//  Created by 辛忠志 on 2017/5/2.
//  Copyright © 2017年 辛忠志. All rights reserved.
//


#define kApplicationShared  [UIApplication sharedApplication]
#define arcWitch [UIScreen mainScreen].bounds.size.width/2
#define arcHeight [UIScreen mainScreen].bounds.size.height/2
#define HRWitch [UIScreen mainScreen].bounds.size.width
#define HRHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "TXPhotoPopupWindowView.h"/*弹窗*/
#import <Photos/Photos.h>
#import "UIImage+cutImage.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImageView *imageview;
@property (strong,nonatomic)TXPhotoPopupWindowView * popView;
@end

@implementation ViewController
#pragma mark - ---------- 懒加载 ----------
-(TXPhotoPopupWindowView *)popView{
    if (!_popView ) {
        _popView = [[NSBundle mainBundle]loadNibNamed:@"TXPhotoPopupWindowView" owner:nil options:nil].firstObject;
        _popView.frame = CGRectMake(0, 0, HRWitch, HRHeight);
    }
    return _popView;
}
#pragma mark - ---------- 生命周期 ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    /*布局*/
    [self config];
    /*操作block*/
    [self Operation];
}

#pragma mark - ---------- 重写属性合成器 ----------
#pragma mark - ---------- IBActions ----------
-(void)btnAction:(UIButton*)sender{
    [kApplicationShared.keyWindow addSubview: self.popView];
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
            NSLog(@"Authorized");/*授权*/
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"Denied");/*拒绝*/
            break;
        case PHAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");/*不确定*/
            break;
        case PHAuthorizationStatusRestricted:
            NSLog(@"Restricted");/*受限制的*/
            break;
        default:
            break;
    }
}
#pragma mark - ---------- 重写父类方法 ----------
#pragma mark - ---------- 公有方法 ----------
#pragma mark - ---------- 私有方法 ----------
-(void)Operation{
    /*拍照*/
    [self.popView returnTakingPhoto:^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"Authorized");/*授权*/
                if (TARGET_IPHONE_SIMULATOR) {
                    NSLog(@"模拟器");
                    return ;
                }
                if (TARGET_OS_IPHONE) {
                    NSLog(@"真机");
                    /*移除视图*/
                    [self.popView removeFromSuperview];
                    UIImagePickerController *pc = [[UIImagePickerController alloc]init];
                    pc.delegate = self;
                    [pc setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [pc setModalPresentationStyle:UIModalPresentationFullScreen];
                    [pc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                    [pc setAllowsEditing:YES];
                    [self presentViewController:pc animated:YES completion:nil];
                    return ;
                }
            }else{
                NSLog(@"Denied or Restricted");/*限制*/
            }
        }];
        
    }];
    /*本地*/
    [self.popView returnLocationPhoto:^{
        /*移除视图*/
        [self.popView removeFromSuperview];
        UIImagePickerController *pc = [[UIImagePickerController alloc]init];
        pc.delegate = self;
        [pc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [pc setModalPresentationStyle:UIModalPresentationFullScreen];
        [pc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [pc setAllowsEditing:YES];
        [self presentViewController:pc animated:YES completion:nil];
    }];
}
#pragma mark 设置图片和按钮
-(void)config{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 50, 30);
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;//让button位于屏幕中央
    [button setImage:[[UIImage imageNamed:@"1.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    self.imageview = [[UIImageView alloc]init];
    self.imageview.frame = CGRectMake(100, 200, 100, 100);
    [self.view addSubview:self.imageview];
}
#pragma mark --- 数据初始化 ---
#pragma mark --- UI布局 ---
#pragma mark --- 网络请求 ---
#pragma mark 列表数据网络请求
#pragma mark --- 设置计时器 ---
#pragma mark - ---------- 协议方法 ----------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%s",__func__);
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%@",NSStringFromCGSize(image.size));
    /*当返回时候进行赋值 赋值可以经过剪切之后再赋值 还可以不剪切就赋值 剪切用上面这句 不剪切用下面那句*/
    UIImage *image2 = [UIImage imagewithImage:image];
    /*不剪切直接赋值*/
//    UIImage *image2 = image;
    self.imageview.image = image2;
}
#pragma mark 即将进入到第二个nav时进行调用
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /*这一步需要判断 只要当照片选择器到了图片剪切的时候就调用 */
    if (navigationController.viewControllers.count == 3)
    {
        Method method = class_getInstanceMethod([self class], @selector(drawRect:));
    
        class_replaceMethod([[[[navigationController viewControllers][2].view subviews][1] subviews][0] class],@selector(drawRect:),method_getImplementation(method),method_getTypeEncoding(method));
    }
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextAddRect(ref, rect);
    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, M_PI*2, NO);
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]setFill];
    /*设置挡板的颜色*/
    CGContextDrawPath(ref, kCGPathEOFill);
    
    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, M_PI*2, NO);
    /*圆外圈线的颜色*/
    [[UIColor blueColor]setStroke];
    CGContextStrokePath(ref);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
