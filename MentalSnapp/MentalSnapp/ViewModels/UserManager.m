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
    [UserDefaults setValue:_userModel.userName forKey:@"userName"];
    [UserDefaults setValue:_userModel.password forKey:@"password"];
    [UserDefaults setValue:_userModel.dateOfBirth forKey:@"dateOfBirth"];
    [UserDefaults setValue:_userModel.phoneNumber forKey:@"phoneNumber"];
    [UserDefaults setValue:_userModel.gender forKey:@"gender"];
    [UserDefaults setValue:_userModel.userId forKey:@"userId"];
    [UserDefaults setValue:_userModel.profilePicURL forKey:@"profilePicURL"];
    [UserDefaults setValue:_userModel.phoneCountryCode forKey:@"phoneCountryCode"];
    
    [UserDefaults synchronize];
}

- (void)setValueInLoggedInUserObjectFromUserDefault
{
    _authorizationToken = [UserDefaults valueForKey:@"authorizationToken"];
    _userModel.email = [UserDefaults valueForKey:@"email"];
    _userModel.userName = [UserDefaults valueForKey:@"userName"];
    _userModel.password = [UserDefaults valueForKey:@"password"];
    _userModel.dateOfBirth = [UserDefaults valueForKey:@"dateOfBirth"];
    _userModel.phoneNumber = [UserDefaults valueForKey:@"phoneNumber"];
    _userModel.gender = [UserDefaults valueForKey:@"gender"];
    _userModel.userId = [UserDefaults valueForKey:@"userId"];
    _userModel.profilePicURL = [UserDefaults valueForKey:@"profilePicURL"];
    _userModel.phoneCountryCode = [UserDefaults valueForKey:@"phoneCountryCode"];
}

//*>    Save Logged in user's info in user default
- (void)removeUserFromUserDefault
{
    [UserDefaults removeObjectForKey:@"authorizationToken"];
    [UserDefaults removeObjectForKey:@"email"];
    [UserDefaults removeObjectForKey:@"userName"];
    [UserDefaults removeObjectForKey:@"password"];
    [UserDefaults removeObjectForKey:@"dateOfBirth"];
    [UserDefaults removeObjectForKey:@"phoneNumber"];
    [UserDefaults removeObjectForKey:@"gender"];
    [UserDefaults removeObjectForKey:@"userId"];
    [UserDefaults removeObjectForKey:@"profilePicURL"];
    [UserDefaults removeObjectForKey:@"phoneCountryCode"];
    
    [UserDefaults synchronize];
}

+ (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
