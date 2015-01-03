#import <Foundation/Foundation.h>

@interface RTClientCredentials : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret;

@end
