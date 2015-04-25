#import <Foundation/Foundation.h>

@class RTApplicationWireframe;

@interface RTApplicationAwareWireframe : NSObject

@property (readonly) RTApplicationWireframe *applicationWireframe;

- (instancetype)initWithApplicationWireframe:(RTApplicationWireframe *)applicationWireframe;

@end
