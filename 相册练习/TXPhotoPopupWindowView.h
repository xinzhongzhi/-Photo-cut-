//
//  TXPhotoPopupWindowView.h
//  TXGU
//
//  Created by 辛忠志 on 16/10/4.
//  Copyright © 2016年 何壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
/* 本地拍照和直接拍照的两个block**/
typedef void (^ReturnTakingPhoto)();
typedef void (^ReturnLocationPhoto)();
@interface TXPhotoPopupWindowView : UIView
/* 弹窗view**/
@property (weak, nonatomic) IBOutlet UIView *backView;
/* 拍照btn**/
@property (weak, nonatomic) IBOutlet UIButton *takingPictureBtn;
/* 本地btn**/
@property (weak, nonatomic) IBOutlet UIButton *localtionPhotoBtn;
/*头部显示文字*/
@property (weak, nonatomic) IBOutlet UILabel *headLabel;


@property (strong,nonatomic)ReturnTakingPhoto returnTakingPhoto;
@property (strong,nonatomic)ReturnLocationPhoto locationPhoto;

-(void)returnTakingPhoto:(ReturnTakingPhoto)block;
-(void)returnLocationPhoto:(ReturnLocationPhoto)block;
@end
