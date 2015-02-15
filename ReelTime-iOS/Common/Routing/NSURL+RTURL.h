#import <Foundation/Foundation.h>

@interface NSURL (RTURL)

- (BOOL)isUserURL;

- (NSString *)usernameFromUserURL;

- (BOOL)isReelURL;

- (NSNumber *)reelIdFromReelURL;

- (BOOL)isVideoURL;

- (NSNumber *)videoIdFromVideoURL;

@end