#import "RTUserProfilePresenter.h"
#import "RTUserProfileWireframe.h"

@interface RTUserProfilePresenter ()

@property RTUserProfileWireframe *wireframe;

@end

@implementation RTUserProfilePresenter

- (instancetype)initWithWireframe:(RTUserProfileWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedAccountSettings {
    [self.wireframe presentAccountSettingsInterface];
}

@end
