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
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:dictionary[@"from_email"] forKey:@"from_email"];
        [_parameters setValue:dictionary[@"description"] forKey:@"description"];
        
        if ([dictionary hasValueForKey:@"screen_shot"]) {
            self.imageData = UIImagePNGRepresentation([dictionary objectForKey:@"screen_shot"]);
            self.dataImageName = @"screen_shot";
            self.imageName = @"screen_shot.jpg";
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
