//
//  ViewController.m
//  WKWebViewOC
//
//  Created by Wangjin on 2017/2/10.
//  Copyright © 2017年 wangjin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"showMobile"];
    [config.userContentController addScriptMessageHandler:self name:@"callMe"];
    [config.userContentController addScriptMessageHandler:self name:@"calculate"];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.wkWebView];
    self.wkWebView.backgroundColor = [UIColor redColor];
//    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"showMobile"]) {
        NSString *phoneNum = message.body[@"value"];
        NSString *js = [NSString stringWithFormat:@"alertSendMsg('wj',\'%@\')",phoneNum];
        [self.wkWebView evaluateJavaScript:js completionHandler:nil];
    }
    if ([message.name isEqualToString:@"callMe"]) {
        NSString *phoneNum = message.body;
        
        NSString *str = [NSString stringWithFormat:@"tel:%@",phoneNum];
        UIWebView *callWebView = [[UIWebView alloc] init];
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebView];
    }
    if ([message.name isEqualToString:@"calculate"]) {
        NSString *phoneNum = message.body;
        
        NSString *sum = [NSString stringWithFormat:@"%f",[message.body[0] doubleValue] + [message.body[1] doubleValue]];
        NSString *js = [NSString stringWithFormat:@"showResult('%@')",sum];
        [self.wkWebView evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)showAlertView:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
