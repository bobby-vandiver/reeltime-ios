#import "RTApplicationAwareWireframe.h"

#import "RTApplicationWireframe.h"

@interface RTApplicationAwareWireframe ()

@property (readwrite) RTApplicationWireframe *applicationWireframe;

@end

@implementation RTApplicationAwareWireframe

- (instancetype)initWithApplicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super init];
    if (self) {
        self.applicationWireframe = applicationWireframe;
    }
    return self;
}

@end
