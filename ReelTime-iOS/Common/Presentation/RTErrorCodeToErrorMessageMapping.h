#import <Foundation/Foundation.h>

@protocol RTErrorCodeToErrorMessageMapping <NSObject>

- (NSString *)errorDomain;

- (NSDictionary *)errorCodeToErrorMessageMapping;

@end
