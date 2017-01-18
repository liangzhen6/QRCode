//
//  QRCodeTool.h
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/17.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface QRCodeTool : NSObject

/**
 生成普通二维码

 @param string 二维码信息
 @param size 图片的size
 @return  生成的二维码图片
 */
+ (UIImage *)createDefaultQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size;

/**
 生成带logo的二维码

 @param string 二维码信息
 @param size 图片的size
 @param logoImage logo的图片
 @return 生成的二维码图片
 */
+ (UIImage *)createLogoQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size logoImage:(UIImage *)logoImage;

/**
 生成彩色二维码

 @param string 二维码信息
 @param size 图片的size
 @param backgroundColor 背景色
 @param mainColor 前景色
 @return 生成的二维码图片
 这里需要注意前景色要比背景色深，否则无法被扫描
 */
+ (UIImage *)createColorQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

@end
