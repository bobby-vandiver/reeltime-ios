#import <Foundation/Foundation.h>

@interface RTEmbeddedURL : NSObject

@property (readonly) NSURL *url;
@property (readonly) NSRange range;

- (instancetype)initWithURL:(NSURL *)url
                      range:(NSRange)range;

@end
