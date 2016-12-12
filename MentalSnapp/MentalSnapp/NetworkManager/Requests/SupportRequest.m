//
//  SupportRequest.m
//  MentalSnapp
//
//  Copyright (c) 2015 Systango. All rights reserved.
//

#import "SupportRequest.h"

@interface SupportRequest()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation SupportRequest

- (id)initWithSupportDetails:(NSMutableDictionary *)dictionary {
    self = [super init];
    
    if(self) {
        NSMutableDictionary *requestParams  = [NSMutableDictionary dictionary];
        [requestParams setValue:dictionary[@"from_email"] forKey:@"from_email"];
        [requestParams setValue:dictionary[@"description"] forKey:@"description"];
        [requestParams setValue:dictionary[@"title"] forKey:@"title"];

        _parameters = [[NSMutableDictionary alloc] initWithDictionary:requestParams];
        
        if ([dictionary hasValueForKey:@"screenshot"]) {
            self.imageData = UIImageJPEGRepresentation(([dictionary objectForKey:@"screenshot"]),0.1);
            self.dataImageName = @"screenshot";
            self.imageName = @"screenshot.jpeg";
            self.imageMimeType = @"image/jpeg";
//            NSData *imageData = UIImagePNGRepresentation(user.profileImage);
//            UIImage *image = [UIImage imageWithData:imageData];
//            _parameters[@"picture"] = image;
        }
        if ([dictionary hasValueForKey:@"log_file"]) {
            self.fileData = [dictionary objectForKey:@"log_file"];
            self.dataFilename = @"log_file";
            self.fileName = @"log_file";
            self.mimeType = @"text/plain";
        }
        
        self.urlPath = KPostSupportLog;
    }
    return self;
}

- (NSMutableDictionary *)getParams {
    return self.parameters;
}

@end
