#import "RTApplicationWireframe.h"

#import "RTLoginWireframe.h"

@interface RTApplicationWireframe ()

@property RTLoginWireframe *loginWirefame;

@end

@implementation RTApplicationWireframe

- (instancetype)initWithLoginWireframe:(RTLoginWireframe *)loginWireframe {
    self = [super init];
    if (self) {
        self.loginWirefame = loginWireframe;
    }
    return self;
}

- (void)presentInitialScreenFromWindow:(UIWindow *)window {
    [self.loginWirefame presentLoginInterfaceFromWindow:window];
}

@end
