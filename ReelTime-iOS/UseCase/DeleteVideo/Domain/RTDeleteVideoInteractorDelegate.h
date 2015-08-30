#import <Foundation/Foundation.h>

@protocol RTDeleteVideoInteractorDelegate <NSObject>

- (void)deleteVideoSucceededForVideoId:(NSNumber *)videoId;

- (void)deleteVideoFailedForVideoId:(NSNumber *)videoId
                          withError:(NSError *)error;

@end
