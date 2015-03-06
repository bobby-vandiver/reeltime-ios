#import <Foundation/Foundation.h>

@interface RTEndpointPathFormatter : NSObject

- (NSString *)formatPath:(NSString *)path
            withClientId:(NSString *)clientId;

- (NSString *)formatPath:(NSString *)path
              withReelId:(NSUInteger)reelId;

- (NSString *)formatPath:(NSString *)path
              withReelId:(NSUInteger)reelId
                 videoId:(NSUInteger)videoId;

- (NSString *)formatPath:(NSString *)path
            withUsername:(NSString *)username;

@end
