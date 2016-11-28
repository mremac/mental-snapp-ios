//
//  Request.h
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, assign) NSInteger requestType;

@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *dataFilename;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *dataImageName;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imageMimeType;

- (NSMutableDictionary *)getParams;
- (instancetype)initForDeviceRegistration;
- (NSString *)appendUrlForDeviceToken:(NSString *)urlString;
+ (NSString *)getURLPath:(NSString *)urlPath;

@end
