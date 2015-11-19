#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RTEndpointPathFormatter;
@class RTCurrentUserService;
@class RTAuthorizationHeaderSupport;

@interface RTPlayerFactory : NSObject

- (instancetype)initWithServerUrl:(NSURL *)serverUrl
                    pathFormatter:(RTEndpointPathFormatter *)pathFormatter
       authorizationHeaderSupport:(RTAuthorizationHeaderSupport *)authorizationHeaderSupport
               currentUserService:(RTCurrentUserService *)currentUserService;

- (AVPlayer *)playerForVideoId:(NSNumber *)videoId;

- (AVPlayer *)playerForVideoURL:(NSURL *)videoURL;

@end
