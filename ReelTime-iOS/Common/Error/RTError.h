#import <Foundation/Foundation.h>

@interface RTError : NSError

@property (readonly) NSError *originalError;

+ (RTError *)errorWithDomain:(NSString *)domain
                        code:(NSInteger)code
                    userInfo:(NSDictionary *)dict
               originalError:(NSError *)error;
@end
