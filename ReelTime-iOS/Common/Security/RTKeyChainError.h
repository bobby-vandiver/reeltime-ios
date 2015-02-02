#import <Foundation/Foundation.h>

extern NSString *const RTKeyChainWrapperErrorDomain;

// TODO: Namespace
typedef NS_ENUM(NSInteger, RTKeyChainError) {
    RTKeyChainErrorMissingKey,
    RTKeyChainErrorItemNotFound,
    RTKeyChainErrorDuplicateItem,
    RTKeyChainErrorUnknown
};