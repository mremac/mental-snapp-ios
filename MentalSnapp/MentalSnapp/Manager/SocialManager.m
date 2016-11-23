//
//  SocialManager.m
//  Skeleton
//
//  Created by Systango on 01/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SocialManager.h"
#import <Social/Social.h>

@implementation SocialManager

+ (SocialManager *)sharedInstance
{
    static SocialManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)showTwitterWithMessage:(NSString *)message onViewController:(UIViewController *)viewController
{
    [self showSocialComposerWithMessage:message onViewController:viewController withServiceType:SLServiceTypeTwitter];
}

- (void)showFacebookWithMessage:(NSString *)message onViewController:(UIViewController *)viewController
{
    [self showSocialComposerWithMessage:message onViewController:viewController withServiceType:SLServiceTypeFacebook];
}

- (void)showSocialComposerWithMessage:(NSString *)message onViewController:(UIViewController *)viewController withServiceType:(NSString *const)serviceType
{
    if ([SLComposeViewController isAvailableForServiceType:serviceType])
    {
        SLComposeViewController *socialSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:serviceType];
        [socialSheetOBJ setInitialText:message];
        [viewController presentViewController:socialSheetOBJ animated:YES completion:nil];
    }
}





/*
 - (id)init {
 //twitter
 [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:kTwitterConsumerKey andSecret:kTwitterSecret];
 [[FHSTwitterEngine sharedEngine] setDelegate:self];
 [[FHSTwitterEngine sharedEngine] loadAccessToken];
 return self;
 }
 
// *************************************************
//Twitter methods
#pragma mark - Twitter Login methods

- (BOOL)isTwitterSessionOpen {
    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    NSString *userID = [[FHSTwitterEngine sharedEngine] authenticatedID];
    if (userID != nil) {
        return YES;
    }
    return NO;
}

- (void)showTwitterLoginViewOnController:(UIViewController*)currentViewController withCompletionBlock:(completionBlock)block {
    
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine] loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog([NSString stringWithFormat:@"\nTwitter response: %d", success]);
        if (success) {
            block(success);
        }
    }];
    
    dispatch_main_async_safe(^{
        [currentViewController presentViewController:loginController animated:YES completion:nil];
    });
    
}

#pragma mark - Twitter Delegate methods
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (NSDictionary *)getTwitterAccessTokenAndSecret {
    FHSToken *fHSToken = [[FHSTwitterEngine sharedEngine] accessToken];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fHSToken.key, kTwitterAccessToken, fHSToken.secret, kTwitterAccessTokenSecret , nil];
    return dict;
}
// *************************************************
//Facebook methods
#pragma mark - Facebook public methods

- (BOOL)isFacebookSessionOpen {
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        return NO;
    }
    else {
        return YES;
    }
    return NO;
}

- (void)showFacebookLoginWithCompletionBlock:(facebookCompletionBlock)block {
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        [self openActiveSessionWithPermissions:@[@"public_profile",@"user_birthday", @"email", @"publish_actions",@"user_friends"] allowLoginUI:YES withBlock:block];
    }
}

#pragma mark - Facebook private methods
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI withBlock:(facebookCompletionBlock)block{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      if (!error) {
                                          NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                            session, kFacebookSession,
                                                                            [NSNumber numberWithInteger:status], kFacebookStatus, nil];
                                          [self handleFBSessionStateChangeWithNotification:sessionStateInfo error:error withBlock:block];
                                          //                                      [self getFacebookFriends];
                                      } else {
                                          [self callCompletionBlock];
                                      }
                                  }];
}

-(void)handleFBSessionStateChangeWithNotification:(NSDictionary *)sessionStateInfo error:(NSError *)error withBlock:(facebookCompletionBlock)block{
    FBSessionState sessionState = [[sessionStateInfo objectForKey:kFacebookStatus] integerValue];
    
    if (!error) {
        if (sessionState == FBSessionStateOpen) {
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(large), email,birthday"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          NSLog([NSString stringWithFormat:@"\n Facebook success response: %@", result]);
                                          block(result, error);
                                      }
                                      else{
                                          NSLogError([NSString stringWithFormat:@"\n Facebook :Failure with error: %@", [error localizedDescription]]);
                                      }
                                  }];
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            NSLogError([NSString stringWithFormat:@"\n Facebook (FBsessionState not open) : FBsessionState : %lud", sessionState]);
        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLogError([NSString stringWithFormat:@"\n Facebook Error :Failure with error: %@", [error localizedDescription]]);
    }
}

- (void)getFacebookFriends {
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                 parameters:@{@"fields": @"first_name, last_name,name, picture.type(large)"}
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  NSLog([NSString stringWithFormat:@"%@", result]);
                                  NSMutableArray *friends = [NSMutableArray array];
                                  if ([result hasValueForKey:@"data"]) {
                                      for (NSDictionary *userDictionary in result[@"data"]) {
                                          User *user = [User getUserFromFacebookResponseDictionary:userDictionary];
                                          if (user) {
                                              [friends addObject:user];
                                          }
                                      }
                                      NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                                      NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
                                      NSArray *sortedArray = [friends sortedArrayUsingDescriptors:descriptors];
                                      if (sortedArray.count) {
                                          [self showFriendsViewWithSource:FACEBOOK withFriends:sortedArray currentViewController:self.currentViewController];
                                      }
                                  }
                              } else {
                                  NSLog([NSString stringWithFormat:@"Fetch Facebook friends error : %@", error.localizedDescription]);
                                  [ApplicationDelegate showFailureBannerOnTopWithTitle:@"Facebook Error" subtitle:error.localizedDescription];
                                  [self callCompletionBlock];
                              }
                              
                              
                          }];
}



// *************************************************

#pragma mark - Public methods
- (NSString *)getFacebookShareDataIntoString:(NSString *)fbToken fbFriendIds:(NSString *)fbFriendIds  {
    NSError *writeError;
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:fbToken,@"access_token", fbFriendIds , @"fabcebook_ids",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&writeError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)getTwitterShareDataIntoString:(NSDictionary *)twitterTokenDict twitterFriendIds:(NSString *)twitterFriendIds {
    NSError *writeError;
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[twitterTokenDict valueForKey:kTwitterAccessToken],@"access_token",[twitterTokenDict valueForKey:kTwitterAccessTokenSecret],@"access_secret",twitterFriendIds,@"twitter_ids",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&writeError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)getVeoZenShareDataIntoString:(NSString *)userIds {
    NSError *writeError;
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:userIds,@"user_ids",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&writeError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



#pragma mark - Public methods (Sharing methods)
- (void)showFriendsAndShareCommunity:(NSString *)communityId shareWithTarget:(ShareWithTarget)shareWithTarget forController:(UIViewController *)sourceController completionBlock:(completionBlock)block {
    self.finishBlock = block;
    self.communityIdsString = communityId;
    self.shareTarget = ShareCommunity;
    self.currentViewController = sourceController;
    [self shareEventWith:shareWithTarget];
}

- (void)showFriendsAndShareEvent:(NSString *)eventId shareWithTarget:(ShareWithTarget)shareWithTarget forController:(UIViewController *)sourceController completionBlock:(completionBlock)block{
    self.finishBlock = block;
    self.eventsIdsString = eventId;
    self.shareTarget = ShareEvent;
    self.currentViewController = sourceController;
    [self shareEventWith:shareWithTarget];
}

- (void)shareEventWith:(ShareWithTarget)shareWithTarget {
    switch (shareWithTarget) {
        case ShareWithFacebook:
            [self shareWithFaceBook];
            return;
        case ShareWithWhatsApp:
            [self shareWithWhatsApp];
            return;
        case ShareWithVeoZen:
            [self shareWithVeoZen];
            return;
    }
}
// *************************************************

#pragma mark - API call methods
- (void)share {
    NSDictionary *dictionary = [self fetchShareWithData];
    if (dictionary == nil) {
        [ApplicationDelegate showFailureBannerOnTopWithTitle:NSLocalizedString(@"CommonBannerTitle", @"") subtitle:NSLocalizedString(@"SelectFriendMessage", @"")];
        return;
    }
    
    if (self.shareTarget == ShareEvent) {
        [[RequestManager alloc] shareEvents:self.eventsIdsString shareDataDictionary:dictionary withCompletionBlock:^(BOOL success, id response) {}];
    } else if (self.shareTarget == ShareCommunity) {
        [[RequestManager alloc] shareCommunities:self.communityIdsString shareDataDictionary:dictionary withCompletionBlock:^(BOOL success, id response) {
        }];
    }
}


- (void)shareWithFaceBook {
    if (![self isFacebookSessionOpen]) {
        [self showFacebookLoginWithCompletionBlock:^(NSDictionary *dictionary, NSError *error ) {
            if (!error) {
                //                [self showFBFriendsView];
                [self getFacebookFriends];
            } else{
                NSLogError([NSString stringWithFormat:@"\nFacebook Error :Failure with error: %@", [error localizedRecoverySuggestion]]);
                [self callCompletionBlock];
            }
        }];
    }
    else {
        //        [self showFBFriendsView];
        [self getFacebookFriends];
    }
}
- (void)shareWithTwitter {
    SocialManager *socialManager = [SocialManager new];
    UIViewController *target = self.currentViewController;
    if (![socialManager isTwitterSessionOpen]) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            if (self.currentViewController) {
                //                [self.currentViewController dismissViewControllerAnimated:NO completion: ^{
                [socialManager showTwitterLoginViewOnController:target withCompletionBlock:^(BOOL success) {
                    if (success) {
                        //                            self.currentViewController = nil;
                        [self showFriendsViewWithSource:TWITTER withFriends:nil currentViewController:self.currentViewController];
                    }
                    //                    }];
                }];
            }
        });
        
    }
    else {
        [self showFriendsViewWithSource:TWITTER withFriends:nil currentViewController:self.currentViewController];
    }
    
}

- (void)shareWithVeoZen {
    [self showFriendsViewWithSource:VEOZEN_FRIENDS withFriends:nil currentViewController:self.currentViewController];
}

- (void)shareWithWhatsApp {
    //    NSString *textToShare = @"Hey! Join me on CliquePick. Get the app now: https://cliquepick.io/";
    //    NSString *urlString = [textToShare stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //    NSString *url = [NSString stringWithFormat:@"whatsapp://send?text=%@",urlString];
    //    NSURL *whatsappURL = [NSURL URLWithString:url];
    //    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
    //        [[UIApplication sharedApplication] openURL: whatsappURL];
    //    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"article_id"] = @"1234";
    //    params[@"$og_title"] = @"MyApp is disrupting apps";
    //    params[@"$og_image_url"] = @"http://yoursite.com/pics/987666.png";
    //    params[@"$desktop_url"] = @"https://cliquepick.io/";
    params[@"setdebug"] = @"1";
    User *user = [[Util sharedInstance] getUser];
    params[@"senderId"] = user.userId;
    if (self.eventsIdsString && self.eventsIdsString.length) {
        params[@"shareType"] = kInviteToEvent;
        params[@"shareIds"] = self.eventsIdsString;
    } else if (self.communityIdsString && self.communityIdsString.length) {
        params[@"shareType"] = kInviteToCommunity;
        params[@"shareIds"] = self.communityIdsString;
    }
    
    
    [[Branch getInstance] getShortURLWithParams:params andChannel:@"sms" andFeature:BRANCH_FEATURE_TAG_SHARE andCallback:^(NSString *url, NSError *error) {
        if (!error){
            NSLog(@"got my Branch link to share: %@", url);
            NSString *textToShare = [NSString stringWithFormat:@"Hey! Join me on CliquePick. Get the app now: %@",url];
            textToShare = [textToShare stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSString *urlString = [NSString stringWithFormat:@"whatsapp://send?text=%@",textToShare];
            
            NSURL *whatsappURL = [NSURL URLWithString:urlString];
            if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                [[UIApplication sharedApplication] openURL: whatsappURL];
            }
        }
    }];
}

#pragma mark - Twitter Get friends (delegate) method

- (void)didSelectedFriends:(NSString *)friendsId {
    NSLog([NSString stringWithFormat:@"\n Twitter selected Ids: %@", friendsId]);
    self.selectedTwitterFriendsString = friendsId;
    if (self.shareTarget == ShareEvent) {
        [self share];
    }
    [self cancelButtonTapped];
}

- (void)didSelectedVeoZenUsers:(NSString *)userIdsString{
    NSLog([NSString stringWithFormat:@"\n Selected cliquepick user Ids: %@", userIdsString]);
    if (userIdsString && userIdsString.length) {
        self.selectedVeoZenUserIdsString = userIdsString;
        [self share];
    }
    [self cancelButtonTapped];
}

- (void)didSelectedFacebookFriends:(NSString *)userIdsString{
    NSLog([NSString stringWithFormat:@"\n Selected cliquepick user Ids: %@", userIdsString]);
    if (userIdsString && userIdsString.length) {
        self.selectedFBFriendsString = userIdsString;
        [self share];
    }
    [self cancelButtonTapped];
}

- (void)cancelButtonTapped {
    [self callCompletionBlock];
    [ApplicationDelegate.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
}



//#pragma mark - FBTaggablefriendsViewControllerDelegate methods
//
//- (void)facebookViewControllerCancelWasPressed:(FBViewController *)sender {
//    [ApplicationDelegate.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//}
//
//- (void)facebookViewControllerDoneWasPressed:(FBViewController *)sender {
//    if ([sender isKindOfClass:[FBTaggableFriendPickerViewController class]]) {
//        selectedFBFriends = ((FBTaggableFriendPickerViewController *)sender).selection;
//        [self share];
//    }
//    [ApplicationDelegate.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//}


#pragma mark - Private methods

- (void)callCompletionBlock {
    if (self.finishBlock) {
        self.finishBlock(YES);
        self.finishBlock = nil;
    }
}

- (void)dismissAndShowController:(UINavigationController *)navigationController {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.currentViewController presentViewController:navigationController animated:NO completion:nil];
    });
}

- (NSDictionary *)fetchShareWithData {
    isSharing = NO;
    NSMutableDictionary *shareDataDictionary = [NSMutableDictionary dictionary];
    if (self.selectedFBFriendsString && self.selectedFBFriendsString.length > 0) {
        isSharing = YES;
        //        NSMutableArray *friendsId = [NSMutableArray array];
        //        for (NSDictionary *friend in selectedFBFriends) {
        //            if ([friend hasValueForKey:@"id"]) {
        //                [friendsId addObject:[friend valueForKey:@"id"]];
        //            }
        //        }
        //        NSString *fbFriendsId = [friendsId componentsJoinedByString:@","];
        NSString *fbToken = [[[FBSession activeSession] accessTokenData] accessToken];
        shareDataDictionary[keyFaceBookData] = [self getFacebookShareDataIntoString:fbToken fbFriendIds:self.selectedFBFriendsString];
    }
    
    if (self.selectedTwitterFriendsString != nil && self.selectedTwitterFriendsString.length > 0) {
        isSharing = YES;
        NSDictionary *twitterTokenDict = [[SocialManager alloc] getTwitterAccessTokenAndSecret];
        shareDataDictionary[keyTwitterData] = [self getTwitterShareDataIntoString:twitterTokenDict twitterFriendIds:self.selectedTwitterFriendsString];
    }
    
    if (self.selectedVeoZenUserIdsString != nil && self.selectedVeoZenUserIdsString.length > 0) {
        isSharing = YES;
        shareDataDictionary[keySelectedVeoZenUserIds] = [[SocialManager sharedInstance] getVeoZenShareDataIntoString:self.selectedVeoZenUserIdsString];
    }
    
    if (!isSharing) {
        return nil;
    }
    return shareDataDictionary;
}

- (void)showFriendsViewWithSource:(FriendSource)source withFriends:(NSArray *)friends currentViewController:(UIViewController *)currentViewController{
    UIStoryboard * shareStoryboard = [UIStoryboard storyboardWithName:kShareStoryBoard bundle:nil];
    FriendsFollowersViewController *friendTableViewController = [shareStoryboard instantiateViewControllerWithIdentifier:kFriendsFollowersViewControllerIdentifier];//Loading controller from nib with their Id
    friendTableViewController.friendSource = source;
    friendTableViewController.friendSelectionPurpose = CHOOSE_FRIENDS_TO_SHARE;
    friendTableViewController.currentViewController = self.currentViewController;
    friendTableViewController.delegate = self;
    if (friends) {
        friendTableViewController.friends = [NSMutableArray arrayWithArray:friends];
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:friendTableViewController];
    [self dismissAndShowController:navigationController];
}

- (void)showFBFriendsView {
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:kMainStoryBoard bundle:nil];
    FBTaggableFriendPickerViewController *taggableFriendPickerViewController = [mainStoryboard instantiateViewControllerWithIdentifier:kFBTaggableFriendPickerViewControllerIdentifier];//Loading controller from nib with their Id
    [taggableFriendPickerViewController loadData];
    taggableFriendPickerViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:taggableFriendPickerViewController];
    navigationController.navigationBarHidden = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.currentViewController presentViewController:navigationController animated:NO completion:nil];
    });
    
}


#pragma mark - API calls

- (void)sendShareDetailToServer:(NSDictionary *)params {
    
    if (![params hasValueForKey:@"senderId"]) {
        return;
    }
    
    User *user = [[Util sharedInstance] getUser];
    NSString *senderId = params[@"senderId"];
    if ([user.userId isEqualToString:senderId]) {
        return;
    }
    NSString *shareType = params[@"shareType"];
    NSString *eventOrCommunityIds = params[@"shareIds"];
    if([shareType isEqualToString:kInviteToEvent]) {
        [[RequestManager alloc] remoteEventInviteByUserId:senderId ofEvents:eventOrCommunityIds withCompletionBlock:^(BOOL success, id response){
            if(success){
                dispatch_main_async_safe(^{
                    NSString *message = response;
                    NSLog(@"%@",message);
                })
            }
        }];
    } else if ([shareType isEqualToString:kInviteToCommunity]) {
        [[RequestManager alloc] remoteCommunityInviteByUserId:user.userId ofCommunities:eventOrCommunityIds withCompletionBlock:^(BOOL success, id response){
            if(success){
                dispatch_main_async_safe(^{
                    NSString *message = response;
                    NSLog(@"%@",message);
                })
            }
        }];
    }
}*/

@end
