#import "RTThumbnail.h"

@implementation RTThumbnail

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

- (BOOL)isEqualToThumbnail:(RTThumbnail *)thumbnail {
    return [self.data isEqual:thumbnail.data];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTThumbnail class]]) {
        return NO;
    }
    
    return [self isEqualToThumbnail:(RTThumbnail *)object];
}

- (NSUInteger)hash {
    return [self.data hash];
}

@end
