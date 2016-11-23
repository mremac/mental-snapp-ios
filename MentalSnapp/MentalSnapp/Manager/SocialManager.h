//
//  SocialManager.h
//  Skeleton
//
//  Created by Systango on 01/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SocialManager : NSObject

+ (SocialManager *)sharedInstance;

- (void)showTwitterWithMessage:(NSString *)message onViewController:(UIViewController *)viewController;
- (void)showFacebookWithMessage:(NSString *)message onViewController:(UIViewController *)viewController;


/*
 typedef void(^GetFriendsBlock)(NSArray *friends);
 
 typedef void(^facebookCompletionBlock)(NSDictionary *dictionary , NSError *error);
 
 - (BOOL)isTwitterSessionOpen;
- (NSString *)loadAccessToken;
- (void)showTwitterLoginViewOnController:(UIViewController*)currentViewController withCompletionBlock:(completionBlock)block;

- (BOOL)isFacebookSessionOpen;
- (void)showFacebookLoginWithCompletionBlock:(facebookCompletionBlock)block;
- (NSDictionary *)getTwitterAccessTokenAndSecret;
- (NSString *)getFacebookShareDataIntoString:(NSString *)fbToken fbFriendIds:(NSString *)fbFriendIds;
- (NSString *)getTwitterShareDataIntoString:(NSDictionary *)twitterTokenDict twitterFriendIds:(NSString *)twitterFriendIds ;
- (NSString *)getVeoZenShareDataIntoString:(NSString *)userIds;

- (void)showFriendsAndShareEvent:(NSString *)eventId shareWithTarget:(ShareWithTarget)shareWithTarget forController:(UIViewController *)sourceController completionBlock:(completionBlock)block;
- (void)showFriendsAndShareCommunity:(NSString *)communityId shareWithTarget:(ShareWithTarget)shareWithTarget forController:(UIViewController *)sourceController completionBlock:(completionBlock)block;

- (void)sendShareDetailToServer:(NSDictionary *)params;*/

@end
