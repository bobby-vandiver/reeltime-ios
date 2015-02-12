#import "RTStringWithEmbeddedURLs.h"
#import "RTEmbeddedURL.h"

@interface RTStringWithEmbeddedURLs ()

@property (readwrite, copy) NSString *string;
@property (readwrite) NSMutableArray *embeddedURLsList;

@end

@implementation RTStringWithEmbeddedURLs

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        self.string = string;
        self.embeddedURLsList = [NSMutableArray array];
    }
    return self;
}

- (void)addLinkToURL:(NSURL *)url
           forString:(NSString *)string {
    NSRange range = [self.string rangeOfString:string];

    if (range.location != NSNotFound) {
        RTEmbeddedURL *embeddedUrl = [[RTEmbeddedURL alloc] initWithURL:url range:range];
        [self.embeddedURLsList addObject:embeddedUrl];
    }
}

- (NSArray *)embeddedURLs {   
    return self.embeddedURLsList;
}

@end
