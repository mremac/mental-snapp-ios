//
//  AppSettings.h
//  Skeleton
//
//  Created by Systango on 06/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : JSONModel

@property (nonatomic, strong) NSString *NetworkMode;
@property (nonatomic, strong) NSString *LocalURL;
@property (nonatomic, strong) NSString *ProductionURL;
@property (nonatomic, strong) NSString *StagingURL;
@property (nonatomic, strong) NSString *URLPathSubstring;
@property (nonatomic, assign) BOOL EnableSecureConnection;
@property (nonatomic, assign) BOOL EnablePullToRefresh;
@property (nonatomic, assign) BOOL EnableBanner;
@property (nonatomic, assign) BOOL EnableFlurry;
@property (nonatomic, assign) BOOL EnableCoreData;
@property (nonatomic, assign) BOOL EnableTwitter;
@property (nonatomic, assign) BOOL EnableFacebook;
@property (nonatomic, strong) NSString *StagingApteligentKey;
@property (nonatomic, strong) NSString *ProductionApteligentKey;

@end
