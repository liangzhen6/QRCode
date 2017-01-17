//
//  QRCodeTool.m
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/17.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "QRCodeTool.h"

@implementation QRCodeTool

+ (CIImage *)createCIImageWithData:(NSString *)string imageViewSize:(CGSize)size {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    //    L　: 7% M　: 15% Q　: 25% H　: 30%     H最高不可超过30%否则不能被识别
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    
    CGFloat scale = size.width / CGRectGetWidth(outPutImage.extent);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale); // scale 为放大倍数
    CIImage *transformImage = [outPutImage imageByApplyingTransform:transform];
    
    return transformImage;
}

+ (UIImage *)createDefaultQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size {

    CIImage * transformImage = [QRCodeTool createCIImageWithData:string imageViewSize:size];
    // 保存
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:transformImage fromRect:transformImage.extent];
    UIImage *qrCodeImage = [UIImage imageWithCGImage:imageRef];
//    UIImage *qrCodeImage = [UIImage imageWithCIImage:transformImage];
    
    return qrCodeImage;
}

+ (UIImage *)createLogoQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size logoImage:(UIImage *)logoImage {
    
    UIImage * defaultQRCodeImage = [QRCodeTool createDefaultQRCodeWithData:string imageViewSize:size];

    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -

    UIGraphicsBeginImageContext(defaultQRCodeImage.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [defaultQRCodeImage drawInRect:CGRectMake(0, 0, defaultQRCodeImage.size.width, defaultQRCodeImage.size.height)];
    //这里我们把logo图片的宽高都设置成二维码的0.25倍，那么面积就是原二维码的0.25*0.25 = 0.0625<7% 即使我们使用最低的纠错水平也能被识别，这里注意，logo图片的面积不能超过原二维码的30%
    CGFloat icon_imageW = defaultQRCodeImage.size.width * 0.25;
    CGFloat icon_imageH = defaultQRCodeImage.size.height * 0.25;
    CGFloat icon_imageX = (defaultQRCodeImage.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (defaultQRCodeImage.size.height - icon_imageH) * 0.5;
    
    [logoImage drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 获取当前画得的这张图片
    UIImage *logoQRCodeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();

    return logoQRCodeImage;

}


+ (UIImage *)createColorQRCodeWithData:(NSString *)string imageViewSize:(CGSize)size backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    
    CIImage * defaultQRCodeCIImage = [QRCodeTool createCIImageWithData:string imageViewSize:size];
    
    // 创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    // 设置默认值
    [color_filter setDefaults];
    
    //KVC 给私有属性赋值
    [color_filter setValue:defaultQRCodeCIImage forKey:@"inputImage"];
    
    //需要使用 CIColor
    [color_filter setValue:mainColor forKey:@"inputColor0"];
    [color_filter setValue:backgroundColor forKey:@"inputColor1"];
    //注意主色一定要比背景色深才能被扫出来
    
    // 设置输出
    CIImage * colorCIImage = [color_filter outputImage];
    
    // 保存
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:colorCIImage fromRect:colorCIImage.extent];
    UIImage * colorQRCodeImage = [UIImage imageWithCGImage:imageRef];

    
//    UIImage * colorQRCodeImage = [UIImage imageWithCIImage:colorCIImage];
    
    return colorQRCodeImage;


}






/*

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGFloat)widthAndHeight {
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    return newImage;
}
 */


@end
