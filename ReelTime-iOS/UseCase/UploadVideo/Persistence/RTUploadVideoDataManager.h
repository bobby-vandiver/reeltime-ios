#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTUploadVideoDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)uploadVideo:(NSURL *)videoUrl
          thumbnail:(NSURL *)thumbnailUrl
          withTitle:(NSString *)title
             toReel:(NSString *)reel
            success:(VideoCallback)success
            failure:(ArrayCallback)failure;


@end
