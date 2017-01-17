//
//  ViewController.m
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/17.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeCreateVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//二维码生成
- (IBAction)QRCodeCreate:(id)sender {
    QRCodeCreateVC * qRCodeVC = [[QRCodeCreateVC alloc] init];
    [self.navigationController pushViewController:qRCodeVC animated:YES];
}

//二维码识别
- (IBAction)QRCodeIdentify:(id)sender {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
