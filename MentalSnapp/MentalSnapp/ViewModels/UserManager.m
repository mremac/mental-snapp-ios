//
//  UserManager.m
//  MentalSnapp
//

#import "UserManager.h"

@implementation UserManager

static UserManager *userManager = nil;
static dispatch_once_t userOnceToken;

+ (UserManager *)sharedManager
{
    dispatch_once(&userOnceToken, ^{
        userManager = [[UserManager alloc] init];
    });
    return userManager;
}

- (id)init {
    self = [super init];
    if(self)
    {
        _userModel = [UserModel new];
    }
    
    return self;
}

- (void)saveLoggedinUserInfoInUserDefault
{
    [UserDefaults setBool:YES forKey:kIsUserLoggedIn];
    
    [UserDefaults setValue:_authorizationToken forKey:@"authorizationToken"];
    [UserDefaults setValue:_userModel.email forKey:@"email"];
    
    [UserDefaults synchronize];
}

- (void)setValueInLoggedInUserObjectFromUserDefault
{
    _authorizationToken = [UserDefaults valueForKey:@"authorizationToken"];
    _userModel.email = [UserDefaults valueForKey:@"email"];
}

//*>    Save Logged in user's info in user default
- (void)removeUserFromUserDefault
{
    [UserDefaults removeObjectForKey:@"authorizationToken"];
    [UserDefaults removeObjectForKey:@"email"];
    
    [UserDefaults synchronize];
}

@end
