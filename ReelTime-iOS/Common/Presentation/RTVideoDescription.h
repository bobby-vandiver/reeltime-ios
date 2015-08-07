#import <Foundation/Foundation.h>

@class RTThumbnail;

@interface RTVideoDescription : NSObject

@property (readonly, copy) NSString *title;
@property (readonly, copy) NSNumber *videoId;
@property (readonly, copy) NSData *thumbnailData;

+ (RTVideoDescription *)videoDescriptionWithTitle:(NSString *)title
                                          videoId:(NSNumber *)videoId
                                    thumbnailData:(NSData *)thumbnailData;

- (BOOL)isEqualToVideoDescription:(RTVideoDescription *)videoDescription;

@end
