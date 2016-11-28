//
//  UserRequest.h
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"

@interface UserRequest : Request
    
- (id)initForEditUser:(UserModel *)user;
- (id)initForChangePassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword ;
- (id)initForUserDetail:(UserModel *)user;
- (id)initForUserLogout:(UserModel *)user;
- (id)initForUserDeactivate:(UserModel *)user;
- (NSMutableDictionary *)getParams;

@end
