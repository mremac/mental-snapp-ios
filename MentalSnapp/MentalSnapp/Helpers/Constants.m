//
//  Constants.m
//  Skeleton
//
//  Created by Systango on 12/22/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Constants.h"
#define ns NSString

#pragma mark - Constant

ns * kEmptyString = @"";
ns * keyDeviceToken = @"DeviceToken";
ns * kPlistFileName = @"AppSettings";
ns *kBoolTrue = @"true";

#pragma mark - Network keys

ns * kInsecureProtocol = @"http://";
ns * kSecureProtocol = @"https://";
ns * kLocalEnviroment = @"LOCAL";
ns * kStagingEnviroment = @"STAGING";
ns * kLiveEnviroment = @"LIVE";

#pragma mark - Json key

ns * kJsonKeyName = @"name";
ns * kJsonKeyId = @"id";

#pragma mark - Session keys

ns * kSessionCookies = @"session_cookies"; // application session

#pragma mark - Push Notifications

ns * kAPSKey = @"aps";

#pragma mark - Other constants
ns *kAfter = @"after";
ns *kBefore = @"before";
ns *kJPage = @"page";
ns *kJPerPage = @"per_page";
ns *kJlimit = @"limit";

#pragma mark - Userdefault keys
ns * kUserEmail = @"UserEmail";
ns * kUserPassword = @"UserPassword";
ns * kRememberMe = @"RememberMe";
ns *kIsUserLoggedIn = @"IsUserLoggedIn";

#pragma mark - StoryBboard Identifier
ns * KProfileViewControllerIdentifier  = @"ProfileViewController";
ns * KProfileStoryboard = @"ProfileStoryboard";
ns * KChangePasswordViewController = @"ChangePasswordViewController";
ns * KSupportScreenViewController  = @"SupportScreenViewController";
ns *kGuidedExcerciseViewController = @"GuidedExcerciseViewController";
ns *kExcerciseSubCategoryViewController = @"ExcerciseSubCategoryViewController";
ns *kSubCategoryDetailViewController = @"SubCategoryDetailViewController";

#pragma mark - API URL
ns *kLoginAPI = @"/api/v1/authenticate";
ns *kSignUpAPI = @"/api/v1/users";
ns *kForgotPassAPI = @"/api/v1/users/forgot_password";
ns *KUserAPI = @"/api/v1/users/%@";
ns *kChangePassword = @"api/v1/users/update_password";
ns *kDeactivateUser = @"api/v1/users/deactivate_account";
ns *KPostSupportLog = @"api/v1/supports/record";
ns *KGetGuidedExcercise = @"api/v1/guided_exercise";
ns *KGetSubCategoryExcercise = @"api/v1/guided_exercise/%@/sub_categories";

#pragma mark - StoryBoard segue identifiers
#pragma mark Main

ns *kGoToReportIssueScreen = @"goToReportIssueScreen";
ns *kGoToQueuedExercisesScreen = @"goToQueuedExercisesScreen";
ns *kGoToSignUp = @"toSignUp";
ns *kGoToForgotPasswordFirstScreen = @"GoToForgotPasswordFirstViewController";
ns *kGoToForgotPasswordSecondScreen = @"GoToForgotPasswordSecondViewController";
ns *kPickerViewController = @"PickerViewController";

#pragma mark - TableViewCell identifiers

ns *kMoreScreenTableViewCellIdentifier = @"MoreScreenTableViewCellIdentifier";
ns *kguidedExcerciseCellCollectionViewCell = @"guidedExcerciseCellCollectionViewCell";
ns *kSubCategoryExcerciseTableViewCell = @"SubCategoryTableViewCell";

#pragma mark - S3Buckets

ns *kLiveProfileImageBucket = @"mentalsnapp/production/profile_images";
ns *kLiveVideoBucket = @"mentalsnapp/production/videos";

ns *kStagingProfileImageBucket = @"mentalsnapp/staging/profile_images";
ns *kStagingVideoBucket = @"mentalsnapp/staging/videos";

