#import <Foundation/Foundation.h>

@interface RTOAuth2TokenError : NSObject

@property (nonatomic, copy) NSString *errorCode;
@property (nonatomic, copy) NSString *errorDescription;

@end
