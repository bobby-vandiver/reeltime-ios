#import <Foundation/Foundation.h>

extern NSString *const RTKeyChainWrapperErrorDomain;

typedef NS_ENUM(NSInteger, RTKeyChainErrors) {
    ItemNotFound,
    DuplicateItem,
    Unknown
};