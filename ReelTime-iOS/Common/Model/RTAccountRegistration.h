#import <Foundation/Foundation.h>

@interface RTAccountRegistration : NSObject

@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *password;
@property (nonatomic, readonly, copy) NSString *email;
@property (nonatomic, readonly, copy) NSString *displayName;
@property (nonatomic, readonly, copy) NSString *clientName;

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
                           email:(NSString *)email
                     displayName:(NSString *)displayName
                      clientName:(NSString *)clientName;
@end
