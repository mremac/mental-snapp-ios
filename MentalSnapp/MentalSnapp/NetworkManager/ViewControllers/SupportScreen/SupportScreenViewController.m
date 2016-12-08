//
//  SupportScreenViewController.m
//  mental Snapp
//
//  Copyright (c) 2015 Systango. All rights reserved.
//

#import "SupportScreenViewController.h"
#import "GZIP.h"
#import "UserManager.h"
#import "RequestManager.h"

@interface SupportScreenViewController ()
@property (strong, nonatomic) IBOutlet UIView *textViewContainer;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) UIImage *attachedScreenShot;
@property (strong, nonatomic) IBOutlet UIButton *screenShotButton;
@property (strong, nonatomic) IBOutlet UIButton *attachmentButton;
@property (nonatomic, strong) NSData *textFileContentsData;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

- (IBAction)attachScreenShotAction:(id)sender;
- (IBAction)sendButtonAction:(id)sender;

@end

NSString *const supportTextViewPlaceholder = @"Write your text...";

@implementation SupportScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setPlaceHolderFor:self.textView];
    [self setNavigationBarButtonTitle:@"Report an Issue"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
    [self performSelectorInBackground:@selector(fetchLogs) withObject:(nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

#pragma mark - Private Methods

- (NSData *)fetchLogs
{
    NSString *fetchLogString = [[SMobiLogger sharedInterface] fetchLogs];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    fetchLogString = [[NSString stringWithFormat:@"Version %@ (%@) ,",
      majorVersion, minorVersion] stringByAppendingString: fetchLogString];
    
    self.textFileContentsData = [[fetchLogString dataUsingEncoding:NSUTF8StringEncoding] gzippedData];
    
    return self.textFileContentsData;
}

- (BOOL)isLogFileAttached
{
    if(self.textFileContentsData == nil)
    {
        [self fetchLogs];
    }
    return YES;
}

- (void)setPlaceHolderFor:(UITextView *)textView
{
    if(textView.text.length == 0){
        [self setPlaceHolderText:textView];
    }
}

- (void)setPlaceHolderText:(UITextView *)textView
{
    self.textView.textAlignment = NSTextAlignmentLeft;
    textView.textColor = [UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0f];
    textView.text = supportTextViewPlaceholder;
}

- (void)selectPhoto {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [ApplicationDelegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];
    } else  {
        [Banner showFailureBannerWithSubtitle:@"Photo libarary not available."];
    }
}

#pragma mark - Text View Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:supportTextViewPlaceholder] ) {
        textView.text = @"";
        self.textView.textAlignment = NSTextAlignmentLeft;
    }
    textView.textColor = [UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0f];
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self setPlaceHolderFor:textView];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.attachedScreenShot = chosenImage;
    [[self attachmentButton] setImage:[UIImage imageNamed:@"popupCancel"] forState:UIControlStateNormal];
    [[self screenShotButton] setTitle:@"Change screenshot" forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBAction Method Methods

- (IBAction)attachScreenShotAction:(id)sender {
    [self selectPhoto];
}

- (IBAction)sendButtonAction:(id)sender {
    if([self.titleTextField.text isEqualToString:@""]){
        [Banner showFailureBannerWithSubtitle:@"Please enter discription"];
        return;
    }
    if([self isLogFileAttached]){
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.titleTextField.text forKey:@"title"];
        [dictionary setValue:[self.textView.text isEqualToString:supportTextViewPlaceholder]?@"":self.textView.text forKey:@"description"];
        [dictionary setObject:self.textFileContentsData forKey:@"log_file"];
         [dictionary setObject:[[UserManager sharedManager] userModel].email forKey:@"from_email"];
        if(self.attachedScreenShot) {
            [dictionary setObject:self.attachedScreenShot forKey:@"screenshot"];
        }
        [self showInProgress:YES];
        [[RequestManager alloc] sendSupportLogs:dictionary withCompletionBlock:^(BOOL success, id response) {
            [self showInProgress:NO];
            if(success) {
                [self backButtonTapped];
            }
        }];
    }
}

@end
