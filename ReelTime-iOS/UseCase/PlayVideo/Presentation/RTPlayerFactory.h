#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RTEndpointPathFormatter;

@interface RTPlayerFactory : NSObject

- (instancetype)initWithServerUrl:(NSURL *)serverUrl
                    pathFormatter:(RTEndpointPathFormatter *)pathFormatter;

- (AVPlayer *)playerForVideoId:(NSNumber *)videoId;

@end
