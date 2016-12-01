//
//  RequestManager.h
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject

- (void)loginWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)signUpWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)editUserWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)changePassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword withCompletionBlock:(completionBlock)block;
- (void)getUserDetailWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)userLogoutWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;
- (void)userDeactivateWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block;

@end
