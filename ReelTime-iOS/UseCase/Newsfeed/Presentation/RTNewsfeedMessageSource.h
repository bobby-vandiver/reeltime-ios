#import <Foundation/Foundation.h>

@class RTActivityMessage;
@class RTActivity;

@interface RTNewsfeedMessageSource : NSObject

- (RTActivityMessage *)messageForActivity:(RTActivity *)activity;

@end
