//
//  QRCodeSuccessVC.m
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/19.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "QRCodeSuccessVC.h"
#import <WebKit/WebKit.h>
@interface QRCodeSuccessVC ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)WKWebView * webView;

@end

@implementation QRCodeSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLeftBarItme];
    [self openUrl];
    // Do any additional setup after loading the view.
}

- (void)initLeftBarItme {
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)backAction:(UIBarButtonItem *)item {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)openUrl{
    
    NSURL * Url = [NSURL URLWithString:self.string];
    if ([[UIApplication sharedApplication] canOpenURL:Url]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:Url]];
    }else{
        [self.webView loadHTMLString:[self changeStrToJStringWithStr:self.string] baseURL:nil];
    }
    
}


/**将数据转化为 html数据
 */
- (NSString *)changeStrToJStringWithStr:(NSString *)string {
    
    UIColor *fontColor = [UIColor whiteColor];
    NSString * stringValue = string;
    NSString * fontFamily = @"Helvetica";//Helvetica padding-left:3px;padding-Right:3px;
    CGFloat fontSize = 50;
    
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {word-break:break-all;font-size: %f; font-family: \"%@\"; color: %@;text-align:center;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", fontSize, fontFamily, fontColor, stringValue];
    return jsString;
    
}

- (WKWebView *)webView {
    if (_webView==nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:_webView];
    }
    return _webView;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    //    NSString *injectionJSString = @"var script = document.createElement('meta');"
    //    "script.name = 'viewport';"
    //    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    //    "document.getElementsByTagName('head')[0].appendChild(script);";
    //    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    //    [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    
}

//失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    [self.webView loadHTMLString:[self changeStrToJStringWithStr:self.string] baseURL:nil];

}




/**
 KVO  监听进度条
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object==_webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%f",self.webView.estimatedProgress);
    }
    
}


- (void)dealloc {
  //移除监听
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
