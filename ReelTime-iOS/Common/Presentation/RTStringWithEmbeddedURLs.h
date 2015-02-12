#import <Foundation/Foundation.h>

@interface RTStringWithEmbeddedURLs : NSObject 

@property (readonly, copy) NSString *string;
@property (readonly) NSArray *embeddedURLs;

- (instancetype)initWithString:(NSString *)string;

- (void)addLinkToURL:(NSURL *)url
           forString:(NSString *)string;

@end