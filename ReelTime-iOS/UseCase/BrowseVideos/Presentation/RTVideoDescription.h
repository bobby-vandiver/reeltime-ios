#import <Foundation/Foundation.h>

@class RTThumbnail;

@interface RTVideoDescription : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSNumber *videoId;
@property (readonly, copy) NSData *thumbnailData;

+ (RTVideoDescription *)videoDescriptionWithText:(NSString *)text
                                         videoId:(NSNumber *)videoId
                                   thumbnailData:(NSData *)thumbnailData;

@end
