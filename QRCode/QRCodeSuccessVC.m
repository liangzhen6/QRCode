//
//  QRCodeSuccessVC.m
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/19.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "QRCodeSuccessVC.h"
#import <WebKit/WebKit.h>
#define baseTag 156445
@interface QRCodeSuccessVC ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)UIProgressView * progressView;
@property(nonatomic,strong)WKWebView * webView;

@end

@implementation QRCodeSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self openUrl];
    // Do any additional setup after loading the view.
}

- (void)initView {
    
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = barItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50)];
    bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomView];
    //110/64 = 70/40
    NSArray * titles = @[@"OnePage.png",@"NextPage.png"];
    for (NSInteger i = 0; i<2; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20+i*90, 5, 70, 40)];
        [btn setBackgroundImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;
//        [btn setBackgroundImage:[UIImage imageNamed:titles[i]] forState:UIControlStateHighlighted];
        btn.tag = baseTag + i;
        [btn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
    }
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, 5, 70, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = YES;
//    [btn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateHighlighted];
    btn.tag = baseTag + 2;
    [btn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];

    
    
}

- (void)allBtnAction:(UIButton *)btn {
    _progressView.progress = 0.0;
    switch (btn.tag-baseTag) {
        case 0:
        {//后退
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            }
        
        }
            break;
        case 1:
        {//前进
            if ([self.webView canGoForward]) {
                [self.webView goForward];
            }
            
        }
            break;
        case 2:
        {//刷新
            [self.webView reload];
            
        }
            break;
            
        default:
            break;
    }

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
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-50-64)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.backgroundColor = [UIColor clearColor];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (_progressView==nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 42, self.view.bounds.size.width, 2)];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        _progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
        _progressView.progressTintColor = [UIColor colorWithRed:4.0f/255.0f green:179.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    }
    return _progressView;
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
    
//    [self.webView loadHTMLString:[self changeStrToJStringWithStr:self.string] baseURL:nil];

}




/**
 KVO  监听进度条
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object==_webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%f",self.webView.estimatedProgress);
        if (_webView.estimatedProgress<1.0) {
            _progressView.hidden = NO;
//            _progressView.progress = _webView.estimatedProgress;
            [_progressView setProgress:_webView.estimatedProgress animated:YES];

        }else{
            _progressView.hidden = YES;
            _progressView.progress = 0.0;

        }
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
