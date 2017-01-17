//
//  QRCodeCreateVC.m
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/17.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "QRCodeCreateVC.h"
#import "QRCodeTool.h"

@interface QRCodeCreateVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@end

@implementation QRCodeCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createImageAction];
    // Do any additional setup after loading the view from its nib.
}


- (void)createImageAction{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
    [self.ImageView addGestureRecognizer:tap];
}
//保存二维码到相册
- (void)imageTapAction:(UITapGestureRecognizer *)tap {
    if (self.ImageView.image) {
        UIImageWriteToSavedPhotosAlbum(self.ImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
    

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
- (IBAction)createQRCodeAction:(UIButton*)sender {
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 9901:
        {//普通二维码
            [self createDefaultQRCode];
        }
            break;
        case 9902:
        {//带头像的二维码
            [self createLogoQRCode];
        }
            break;
        case 9903:
        {//彩色二维码
            [self createColorQRCode];
        }
            break;
            
        default:
            break;
    }
    
}

//生成普通的二维码
- (void)createDefaultQRCode {
    if (self.textField.text.length) {
      self.ImageView.image = [QRCodeTool createDefaultQRCodeWithData:self.textField.text imageViewSize:self.ImageView.bounds.size];
    }else{
        NSLog(@"请填写二维码信息");
    }
    
}

//生成带logo的二维码
- (void)createLogoQRCode {
    if (self.textField.text.length) {
        UIImage * image = [UIImage imageNamed:@"logo.png"];
        self.ImageView.image = [QRCodeTool createLogoQRCodeWithData:self.textField.text imageViewSize:self.ImageView.bounds.size logoImage:image];
    }else{
        NSLog(@"请填写二维码信息");
    }
    
}

//生成彩色二维码
- (void)createColorQRCode {
    if (self.textField.text.length) {
        CIColor * backgroundColor = [CIColor yellowColor];
        CIColor * mainColor = [CIColor redColor];
        self.ImageView.image = [QRCodeTool createColorQRCodeWithData:self.textField.text imageViewSize:self.ImageView.bounds.size backgroundColor:backgroundColor mainColor:mainColor];
    }else{
        NSLog(@"请填写二维码信息");
    }


}

//退出编辑文档
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
