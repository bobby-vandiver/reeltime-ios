#import <Foundation/Foundation.h>

@interface RTClientCredentials : NSObject

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret;

@end
