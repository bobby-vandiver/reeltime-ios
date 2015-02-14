#import <Foundation/Foundation.h>

@class RTStringWithEmbeddedLinks;
@class RTActivity;

@interface RTNewsfeedMessageSource : NSObject

- (RTStringWithEmbeddedLinks *)messageForActivity:(RTActivity *)activity;

@end
