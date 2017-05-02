//
//  TXPhotoPopupWindowView.m
//  TXGU
//
//  Created by 辛忠志 on 16/10/4.
//  Copyright © 2016年 何壮壮. All rights reserved.
//

#import "TXPhotoPopupWindowView.h"

@implementation TXPhotoPopupWindowView

- (void)awakeFromNib {
    [super awakeFromNib];
    //重新设置BackView的形状
    self.backView.layer.cornerRadius = 6;
    self.backView.layer.masksToBounds = YES;
}
#pragma  mark  ----------本地 和 照相机拍照Click ---------
- (IBAction)takingPhotoBtn:(UIButton *)sender {
    if (self.returnTakingPhoto) {
        self.returnTakingPhoto(sender);
    }
}
- (IBAction)locationPhotoBtn:(UIButton *)sender {
    if (self.locationPhoto) {
        self.locationPhoto(sender);
    }
}
#pragma mark 点击背景实现消失
- (IBAction)popupBackView:(UITapGestureRecognizer *)sender {
    [self removeFromSuperview];
}
-(void)returnTakingPhoto:(ReturnTakingPhoto)block{
    self.returnTakingPhoto = block;
}
-(void)returnLocationPhoto:(ReturnLocationPhoto)block{
    self.locationPhoto = block;
}
@end
