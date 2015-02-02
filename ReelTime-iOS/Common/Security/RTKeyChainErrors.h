#import <Foundation/Foundation.h>

extern NSString *const RTKeyChainWrapperErrorDomain;

// TODO: Namespace
typedef NS_ENUM(NSInteger, RTKeyChainErrors) {
    MissingKey,
    ItemNotFound,
    DuplicateItem,
    Unknown
};