//
//  QRCodeIdentifyVC.m
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/18.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "QRCodeIdentifyVC.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeSuccessVC.h"

@interface QRCodeIdentifyVC ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic)AVCaptureSession * captureSession;
@property(nonatomic)AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;

@end

@implementation QRCodeIdentifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightBarButtonItem];
    [self initCaptureDevice];

    // Do any additional setup after loading the view from its nib.
}

- (void)initCaptureDevice {
    AVCaptureDevice * avCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError * error;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:avCaptureDevice error:&error];
    if (!input) {
        NSLog(@"error=%@",[error localizedDescription]);
        return;
    }
    
    // 3.初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [AVCaptureMetadataOutput new];
    // 3.1设置代理及所在线程
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 3.2设置扫描区域
//    [captureMetadataOutput setRectOfInterest:self.view.bounds];
    captureMetadataOutput.rectOfInterest = CGRectMake(0.05, 0.2, 0.6, 0.6);
    
    // 4.创建会话
    self.captureSession = [[AVCaptureSession alloc] init];
    // 4.1添加输入流
    [self.captureSession addInput:input];
    if ([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }
    // 4.2添加输出流
    if ([self.captureSession canAddOutput:captureMetadataOutput]) {
        [self.captureSession addOutput:captureMetadataOutput];
    }
    
    // 3.3指定元数据类型
    captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeUPCECode,
                                                  AVMetadataObjectTypeCode39Code,
                                                  AVMetadataObjectTypeCode39Mod43Code,
                                                  AVMetadataObjectTypeEAN13Code,
                                                  AVMetadataObjectTypeEAN8Code,
                                                  AVMetadataObjectTypeCode93Code,
                                                  AVMetadataObjectTypeCode128Code,
                                                  AVMetadataObjectTypePDF417Code,
                                                  AVMetadataObjectTypeQRCode, // 二维码
                                                  AVMetadataObjectTypeAztecCode];
    
    // 5创建预览图层
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.captureVideoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    //6.开始会话
    [self.captureSession startRunning];
    

}


#pragma mark ==========AVCaptureMetadataOutputObjectsDelegate==二维码扫描结果代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    // 1、如果扫描完成，停止会话
    [self.captureSession stopRunning];
    
    // 2、删除预览图层
    [self.captureVideoPreviewLayer removeFromSuperlayer];
    
    // 3、设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        NSLog(@"metadataObjects = %@", metadataObjects);
        
        QRCodeSuccessVC * successVC = [[QRCodeSuccessVC alloc] init];
        successVC.string = obj.stringValue;
        [self.navigationController pushViewController:successVC animated:YES];

    }

}


///从相册识别
- (void)initRightBarButtonItem {
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

}


#pragma mark - - - rightBarButtonItenAction 的点击事件
- (void)rightBarButtonItenAction {
    [self readImageFromAlbum];
}

#pragma mark - - - 从相册中读取照片
- (void)readImageFromAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
    imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
    [self presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
}

#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:image];
    }];
}


/** 从相册中识别二维码, 并进行界面跳转 */
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    CIQRCodeFeature *feature = [features firstObject];
    NSString *scannedResult = feature.messageString;
    NSLog(@"result:%@",scannedResult);

    if (scannedResult.length) {
        QRCodeSuccessVC * successVC = [[QRCodeSuccessVC alloc] init];
        successVC.string = scannedResult;
        [self.navigationController pushViewController:successVC animated:YES];
    }
   

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
