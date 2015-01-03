#import <Foundation/Foundation.h>

@interface RTOAuth2Token : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *tokenType;
@property (nonatomic, copy) NSNumber *expiresIn;
@property (nonatomic, copy) NSString *scope;

@end
