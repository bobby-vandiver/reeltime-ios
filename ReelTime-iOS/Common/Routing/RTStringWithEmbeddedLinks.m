#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

@interface RTStringWithEmbeddedLinks ()

@property (readwrite, copy) NSString *string;
@property (readwrite) NSMutableArray *embeddedURLs;

@end

@implementation RTStringWithEmbeddedLinks

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        self.string = string;
        self.embeddedURLs = [NSMutableArray array];
    }
    return self;
}

- (void)addLinkToURL:(NSURL *)url
           forString:(NSString *)string {
    NSRange range = [self.string rangeOfString:string];

    if (range.location != NSNotFound) {
        RTEmbeddedURL *embeddedUrl = [[RTEmbeddedURL alloc] initWithURL:url range:range];
        [self.embeddedURLs addObject:embeddedUrl];
    }
}

- (NSArray *)links {   
    return self.embeddedURLs;
}

@end
