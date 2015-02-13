#import <Foundation/Foundation.h>
#import "RTActivityType.h"

@class RTStringWithEmbeddedLinks;

@protocol RTNewsfeedView <NSObject>

- (void)showMessage:(RTStringWithEmbeddedLinks *)message
    forActivityType:(RTActivityType)type;

- (void)clearMessages;

@end
