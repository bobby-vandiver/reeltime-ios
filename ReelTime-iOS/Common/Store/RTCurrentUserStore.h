#import <Foundation/Foundation.h>

#import "RTKeyChainWrapper.h"

@interface RTCurrentUserStore : NSObject

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper;

- (NSString *)loadCurrentUsernameWithError:(NSError *__autoreleasing *)error;

- (BOOL)storeCurrentUsername:(NSString *)username
                       error:(NSError *__autoreleasing *)error;

@end
