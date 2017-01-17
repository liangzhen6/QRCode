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

+ (UIImage *)createDefaultQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size;

+ (UIImage *)createLogoQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size logoImage:(UIImage *)logoImage;

+ (UIImage *)createColorQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

@end
