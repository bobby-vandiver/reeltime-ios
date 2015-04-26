#import <Foundation/Foundation.h>

@protocol RTServerErrorMessageToErrorCodeMapping <NSObject>

- (NSString *)errorDomain;

- (NSDictionary *)errorMessageToErrorCodeMapping;

@end
