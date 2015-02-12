#import "RTEmbeddedURL.h"

@interface RTEmbeddedURL ()

@property (readwrite) NSURL *url;
@property (readwrite) NSRange range;

@end

@implementation RTEmbeddedURL

- (instancetype)initWithURL:(NSURL *)url
                      range:(NSRange)range {
    self = [super init];
    if (self) {
        self.url = url;
        self.range = range;
    }
    return self;
}

@end
