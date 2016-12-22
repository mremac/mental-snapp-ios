//
//  Util.m
//  Skeleton
//
//  Created by Systango on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Util.h"
#import "GuidedExcercise.h"
#import "RecordViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@implementation Util

+ (void)postNotification:(NSString *)name withDict:(NSDictionary *)dict
{
    NSNotification *notif = [NSNotification notificationWithName:name
                                                          object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

+ (void)saveCustomObject:(id)object toUserDefaultsForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:object forKey:key];
}

+ (id)fetchCustomObjectForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults rm_customObjectForKey:key];
}

+ (BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex =@"^ [0-9]{4} [0-9]{3,6}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

+(BOOL)formatePhoneNumberOftextField:(UITextField *)textField withRange:(NSRange)range ReplacemenString:(NSString *)string
{
    BOOL result = YES;
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    
    if (string.length != 0) {
        NSMutableString *text = [NSMutableString stringWithString:[[textField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
        [text insertString:@" " atIndex:0];
        
        if (text.length > 4)
            [text insertString:@" " atIndex:5];
        
        if (text.length > 11) {
            text = [NSMutableString stringWithString:[text substringToIndex:textField.text.length]];
            result = NO;
        } else {
            textField.text = text;
        }
    }
    return result;
}

+ (UIColor*)getMoodColor:(MoodType)type {
    UIColor *result = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    switch(type) {
        case TheBestMood:
            result = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0f];
            break;
        case VeryGoodMood:
            result = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0f];
            break;
        case GoodMood:
            result = [UIColor colorWithRed:245.0/255.0 green:130.0/255.0 blue:32.0/255.0 alpha:1.0f];
            break;
        case OkMood:
            result = [UIColor colorWithRed:253.0/255.0 green:185.0/255.0 blue:19.0/255.0 alpha:1.0f];
            break;
        case BadMood:
            result = [UIColor colorWithRed:237.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0f];
            break;
        case VeryBadMood:
            result = [UIColor colorWithRed:83.0/255.0 green:79.0/255.0 blue:161.0/255.0 alpha:1.0f];
            break;
        case TheWorstMood:
            result = [UIColor colorWithRed:50.0/255.0 green:0.0/255.0 blue:74.0/255.0 alpha:1.0f];
            break;
        default:
            result = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            break;
    }
    return result;
}

+ (NSString*) getMoodString:(MoodType)type {
    NSString *result = nil;
    switch(type) {
        case TheBestMood:
            result = @"The best";
            break;
        case VeryGoodMood:
            result = @"Very good";
            break;
        case GoodMood:
            result = @"Good";
            break;
        case OkMood:
            result = @"Ok";
            break;
        case BadMood:
            result = @"Bad";
            break;
        case VeryBadMood:
            result = @"Very bad";
            break;
        case TheWorstMood:
            result = @"The worst";
            break;
        default:
            result = @"";
    }
    return result;
}

+(BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)openCameraForRecordExercise:(GuidedExcercise *)exercise
{
    [ApplicationDelegate.tabBarController setSelectTabIndex:2];
    [ApplicationDelegate.tabBarController setSelectedIndex:2];
    UINavigationController *navController = ApplicationDelegate.tabBarController.selectedViewController;
    [navController popToRootViewControllerAnimated:NO];
    RecordViewController *recordViewController = (RecordViewController *)navController.topViewController;
    if([recordViewController isKindOfClass:[RecordViewController class]])
    {
        recordViewController.exercise = exercise;
        [Util openCameraView:recordViewController WithAnimation:NO];
    }
}

+ (void)openCameraView:(id)target WithAnimation:(BOOL)animate {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = target;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
        imgPicker.allowsEditing = NO;
        [imgPicker setVideoMaximumDuration:2*60];
        [[ApplicationDelegate window].rootViewController presentViewController:imgPicker animated:animate completion:nil];
    } else {
        [Banner showFailureBannerWithSubtitle:@"Camera not available."];
    }
}

- (UIImage *)didFinishPickingImageFile:(UIImage *)image fileType:(UploadFileType)fileType completionBlock:(completionBlock)block
{
    NSString *deviceToken = [UserDefaults valueForKey:keyDeviceToken];
    if(!deviceToken || deviceToken.length == 0)
        deviceToken = @"Simulator";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [[NSDate date] getMilliSeconds], deviceToken];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    
    NSURL *imageURL = [NSURL fileURLWithPath:filePath];
    
    //*> Getting size
    NSError *attributesError;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&attributesError];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    S3Manager * s3Manager = [[S3Manager alloc] initWithFileURL:imageURL s3Key:fileName mediaUploadProgressBarView:nil progressBarLabel:nil fileType:fileType contentLength:[NSNumber numberWithUnsignedLongLong:fileSize]];
    [s3Manager uploadFileToS3CompletionBlock:^(BOOL success, id response) {
        block(success, response);
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }];
    
    return image;
}

- (void)didFinishPickingVideoFile:(NSURL *)videoURL withName:(NSString *)videoName fileType:(UploadFileType)fileType completionBlock:(completionBlock)block
{
    NSString *deviceToken = [UserDefaults valueForKey:keyDeviceToken];
    if(!deviceToken || deviceToken.length == 0)
        deviceToken = @"Simulator";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.mov",videoName,[[NSDate date] getMilliSeconds]];

    //*> Getting size
    NSError *attributesError;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:videoURL.path error:&attributesError];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    S3Manager * s3Manager = [[S3Manager alloc] initWithFileURL:videoURL s3Key:fileName mediaUploadProgressBarView:nil progressBarLabel:nil fileType:fileType contentLength:[NSNumber numberWithUnsignedLongLong:fileSize]];
    [s3Manager uploadFileToS3CompletionBlock:^(BOOL success, id response) {
        block(success, response);
    }];
}

+ (NSString *)displayDateWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *dateAndTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSInteger yearAgo = [dateAndTime yearsAgo];
    NSString *dateString;
    
    if(yearAgo == 0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMM"];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        [timeFormatter setDateFormat:@"h:mm a"];
        
        NSString *relativeDateValue = [dateAndTime isToday] ? @"Today" : [dateAndTime isYesterday] ? @"Yesterday" : [dateFormatter stringFromDate:dateAndTime];
        
        dateString = [NSString stringWithFormat:@"%@, %@", relativeDateValue, [[timeFormatter stringFromDate:dateAndTime] lowercaseString]];
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM, yyyy"];
        dateString = [formatter stringFromDate:dateAndTime];
    }
    
    if (dateString && dateString.length > 0)
    {
        return dateString;
    }
    
    return kEmptyString;
}
@end
