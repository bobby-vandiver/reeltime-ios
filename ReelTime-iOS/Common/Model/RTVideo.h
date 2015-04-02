#import <Foundation/Foundation.h>

@class RTThumbnail;

@interface RTVideo : NSObject

@property (nonatomic, copy) NSNumber *videoId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) RTThumbnail *thumbnail;

- (instancetype)initWithVideoId:(NSNumber *)videoId
                          title:(NSString *)title;

- (instancetype)initWithVideoId:(NSNumber *)videoId
                          title:(NSString *)title
                      thumbnail:(RTThumbnail *)thumbnail;

- (BOOL)isEqualToVideo:(RTVideo *)video;

@end
