#import <Foundation/Foundation.h>

@class RTThumbnail;

@interface RTVideoDescription : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSNumber *videoId;
@property (readonly, copy) RTThumbnail *thumbnail;

+ (RTVideoDescription *)videoDescriptionWithText:(NSString *)text
                                         videoId:(NSNumber *)videoId
                                       thumbnail:(RTThumbnail *)thumbnail;

@end
