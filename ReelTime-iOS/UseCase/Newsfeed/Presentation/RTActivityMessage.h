#import <Foundation/Foundation.h>
#import "RTActivityType.h"

@class RTStringWithEmbeddedLinks;

@interface RTActivityMessage : NSObject

@property (readonly) RTStringWithEmbeddedLinks *message;
@property (readonly) RTActivityType type;

+ (RTActivityMessage *)activityMessage:(RTStringWithEmbeddedLinks *)message
                              withType:(RTActivityType)type;

@end
