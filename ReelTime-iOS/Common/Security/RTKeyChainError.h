#import <Foundation/Foundation.h>

extern NSString *const RTKeyChainWrapperErrorDomain;

typedef NS_ENUM(NSInteger, RTKeyChainError) {
    RTKeyChainErrorMissingKey,
    RTKeyChainErrorItemNotFound,
    RTKeyChainErrorDuplicateItem,
    RTKeyChainErrorUnknown
};