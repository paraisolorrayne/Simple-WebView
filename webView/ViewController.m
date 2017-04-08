//
//  ViewController.m
//  webView
//
//  Created by Zup Beta on 06/02/17.
//  Copyright © 2017 Zup Beta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSString *urlStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _urlStr = @"https://www.justwatch.com/br";
    NSURL *uRL = [NSURL URLWithString: _urlStr];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:uRL];
    [self.webView loadRequest:request];
    [self.view addSubview:_webView];
    [super viewDidLoad];
}
- (IBAction)goBackSwipe:(UISwipeGestureRecognizer *)sender {
    [self.webView goBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
