#import <Foundation/Foundation.h>

@interface RTEndpointPathFormatter : NSObject

- (NSString *)formatPath:(NSString *)path
            withClientId:(NSString *)clientId;

- (NSString *)formatPath:(NSString *)path
         withAccessToken:(NSString *)accessToken;

- (NSString *)formatPath:(NSString *)path
            withUsername:(NSString *)username;

- (NSString *)formatPath:(NSString *)path
              withReelId:(NSUInteger)reelId;

- (NSString *)formatPath:(NSString *)path
             withVideoId:(NSUInteger)videoId;

- (NSString *)formatPath:(NSString *)path
              withReelId:(NSUInteger)reelId
                 videoId:(NSUInteger)videoId;

@end
