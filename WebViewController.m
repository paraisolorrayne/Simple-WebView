//
//  WebViewController.m
//
//
//  Created by Lorrayne Paraiso on 03/03/17.
//  Copyright © 2017 DevTech. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewControllerActivitySafari.h"

@interface WebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reviewBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connectInternet];
    
}
- (void)connectInternet {
    NSURL *scrpitURL = [NSURL URLWithString:@"https://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scrpitURL];
    if (data) {
        NSURL *uRL = [NSURL URLWithString:@"http://www.ufu.br/"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURLRequest *request = [NSURLRequest requestWithURL:uRL];
        [self.webView loadRequest:request];
        [self updateToolbarItems];
    } else {
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Sem conexão com a Internet!"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action) {
                                 [view dismissViewControllerAnimated:YES completion:^{
                                     
                                 }];
                             }];
        [view addAction:ok];
        [self presentViewController:view animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goBackSwipe:(UISwipeGestureRecognizer *)sender {
    [self.webView goBack];
}

- (IBAction)backGesture:(UISwipeGestureRecognizer *)sender {
    [self.webView goBack];
}

- (IBAction)reloadTapGesture:(UITapGestureRecognizer *)sender {
    [self.webView reload];
}

- (IBAction)reviewAppStore:(UIBarButtonItem *)sender {
    NSString *iOSAppStoreURLFormat = @"https://itunes.apple.com/gb/app/id1211758309?action=write-review&mt=8";
    NSURL *appStoreReviewUrl = [NSURL URLWithString:iOSAppStoreURLFormat];
    if ([[UIApplication sharedApplication] canOpenURL:appStoreReviewUrl]) {
        [[UIApplication sharedApplication] openURL:appStoreReviewUrl options:@{} completionHandler:nil];
    }
}

- (void)actionButtonTapped:(id)sender {
    NSURL *url = self.webView.request.URL ? self.webView.request.URL : self.request.URL;
    if (url != nil) {
        NSArray *activities = @[[WebViewControllerActivitySafari new]];
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *dc = [UIDocumentInteractionController interactionControllerWithURL:url];
            [dc presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        } else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_0 &&
                UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIPopoverPresentationController *ctrl = activityController.popoverPresentationController;
                ctrl.sourceView = self.view;
                ctrl.barButtonItem = sender;
            }
            [self presentViewController:activityController animated:YES completion:nil];
        }
    }
}

- (IBAction)swipeBack:(UISwipeGestureRecognizer *)sender {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:_webView action:@selector(goBack:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
}

- (void)dealloc {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;
    //self.delegate = nil;
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.webView;
    [self loadRequest:self.request];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
    _refreshBarButtonItem = nil;
    _actionBarButtonItem = nil;
    _reviewBarButtonItem = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters

- (UIWebView*)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WebViewControllerBack"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(goBack:)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)reviewBarButtonItem {
    if (!_reviewBarButtonItem) {
        _reviewBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ReviewAppStore-icon"]
                                                                style: UIBarButtonItemStylePlain target:self
                                                               action:@selector(reviewAppStore:)];
    }
    return _reviewBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WebViewControllerNext"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goForward:)];
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTap:)];
    }
    return _refreshBarButtonItem;
}


- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    }
    return _actionBarButtonItem;
}



#pragma mark - Toolbar

- (void)updateToolbarItems {
    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250.0f;
        fixedSpace.width = 110.0f;
        
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem,
                          fixedSpace, self.reviewBarButtonItem,
                          nil];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    
    else {
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          flexibleSpace, self.reviewBarButtonItem,
                          fixedSpace,
                          nil];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - Target actions

- (IBAction)swipeGoBack:(UISwipeGestureRecognizer *)sender {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:_webView action:@selector(goBack:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)reloadTap:(id)sender {
    [self.webView reload];
}

@end
