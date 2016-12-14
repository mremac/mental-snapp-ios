//
//  UserManager.h
//  MentalSnapp
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface UserManager : NSObject

@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSString *authorizationToken;
@property (assign, nonatomic) BOOL isLoginViaSignUp;
@property (assign, nonatomic) NSInteger topGuideLength;

+ (UserManager *)sharedManager;

- (void)saveLoggedinUserInfoInUserDefault;
- (void)setValueInLoggedInUserObjectFromUserDefault;
- (void)updateProfileURL:(NSString *)profileURL;
- (void)removeUserFromUserDefault;

+ (BOOL)isValidEmail:(NSString *)checkString;
- (void)logoutUser;
@end
