#import <Foundation/Foundation.h>

@interface RTError : NSError

+ (RTError *)errorWithDomain:(NSString *)domain
                        code:(NSInteger)code
                    userInfo:(NSDictionary *)dict
               originalError:(NSError *)error;

- (NSError *)originalError;

@end
