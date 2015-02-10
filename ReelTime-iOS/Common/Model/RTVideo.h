#import <Foundation/Foundation.h>

@interface RTVideo : NSObject

@property (nonatomic, copy) NSNumber *videoId;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithVideoId:(NSNumber *)videoId
                          title:(NSString *)title;

- (BOOL)isEqualToVideo:(RTVideo *)video;

@end
