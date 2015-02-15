#import <Foundation/Foundation.h>

@interface NSURL (RTURL)

@property (readonly) BOOL isUserURL;
@property (readonly) NSString *username;

@property (readonly) BOOL isReelURL;
@property (readonly) NSNumber *reelId;

@property (readonly) BOOL isVideoURL;
@property (readonly) NSNumber *videoId;

@end