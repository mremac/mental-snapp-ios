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

#pragma mark - Userdefault keys
ns * kUserEmail = @"UserEmail";
ns * kUserPassword = @"UserPassword";
ns * kRememberMe = @"RememberMe";
ns *kIsUserLoggedIn = @"IsUserLoggedIn";

#pragma mark - StoryBboard Identifier
ns * KProfileViewControllerIdentifier  = @"ProfileViewController";
ns * KProfileStoryboard = @"ProfileStoryboard";
ns * KChangePasswordViewController = @"ChangePasswordViewController";

#pragma mark - API URL
ns *KUserAPI = @"/users/%@";
ns *kLoginAPI = @"/api/v1/authenticate";
ns *kSignUpAPI = @"/api/v1/users";

#pragma mark - StoryBoard segue identifiers
#pragma mark Main

ns *kGoToReportIssueScreen = @"goToReportIssueScreen";
ns *kGoToQueuedExercisesScreen = @"goToQueuedExercisesScreen";
ns *kGoToSignUp = @"toSignUp";

#pragma mark - TableViewCell identifiers

ns *kMoreScreenTableViewCellIdentifier = @"MoreScreenTableViewCellIdentifier";



