#import <Foundation/Foundation.h>

@interface RTThumbnail : NSObject

@property (nonatomic) NSData *data;

- (instancetype)initWithData:(NSData *)data;

- (BOOL)isEqualToThumbnail:(RTThumbnail *)thumbnail;

@end
