#import <Foundation/Foundation.h>

@interface RTUserCredentials : NSObject

@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *password;

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password;

@end
