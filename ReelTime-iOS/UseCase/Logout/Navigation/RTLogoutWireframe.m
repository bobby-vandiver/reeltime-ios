#import "RTLogoutWireframe.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTLogoutWireframe ()

@property RTLoginWireframe *loginWireframe;

@end

@implementation RTLogoutWireframe

- (instancetype)initWithLoginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.loginWireframe = loginWireframe;
    }
    return self;
}

- (void)presentLoginInterface {
    [self.loginWireframe presentLoginInterface];
}

@end
