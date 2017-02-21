//
//  ScottCrownViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottCrownViewController.h"
#import <WebKit/WebKit.h>
#import "UIScreen+ScottExtension.h"
#import "SVProgressHUD.h"

@interface ScottCrownViewController ()<UIScrollViewDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;


@end

@implementation ScottCrownViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen scott_screenWidth], [UIScreen scott_screenHeight] - 64)];
    _webView.scrollView.delegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD show];
}

/// 页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:error.description];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
