//
//  TermsViewController.m
//  MentalSnapp
//

#import "TermsViewController.h"

@interface TermsViewController ()

@property(weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController != nil) {
        self.navigationController.navigationBar.hidden = NO;
    }
    
    NSString *content;
    if (_contentType == TermsAndCondition) {
        content = @"MentaSnappTerms.rtf";
    } else if (_contentType == PrivacyPolicy) {
        content = @"MentalSnappPrivacy.rtf";
    }
    _webView.delegate = (id)self;
    NSString *filePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:content];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    [_webView loadData:[NSData dataWithContentsOfFile:filePath] MIMEType:@"text/rtf" textEncodingName:@"utf-8" baseURL:fileURL];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.navigationController != nil) {
        self.navigationController.navigationBar.hidden = self.tabBarController == nil;
    }
}

- (void)initialSetup {
    if (_contentType == TermsAndCondition) {
        [self setNavigationBarButtonTitle:@"Terms and Conditions"];
    } else if (_contentType == PrivacyPolicy) {
        [self setNavigationBarButtonTitle:@"Privacy Policy"];
    }
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
}

@end
