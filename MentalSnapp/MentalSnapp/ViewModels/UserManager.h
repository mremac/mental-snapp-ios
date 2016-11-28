//
//  UserManager.h
//  MentalSnapp
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface UserManager : NSObject

@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSString *authorizationToken;

+ (UserManager *)sharedManager;

- (void)saveLoggedinUserInfoInUserDefault;
- (void)setValueInLoggedInUserObjectFromUserDefault;
- (void)removeUserFromUserDefault;

+ (BOOL)isValidEmail:(NSString *)checkString;
- (void)logoutUser;
@end
