#import <Foundation/Foundation.h>

@interface RTEndpointPathFormatter : NSObject

- (NSString *)formatPath:(NSString *)path
          withParameters:(NSDictionary *)parameters;

@end
