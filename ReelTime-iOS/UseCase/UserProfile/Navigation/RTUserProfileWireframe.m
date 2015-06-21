#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"

#import "RTAccountSettingsWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTUserProfileWireframe ()

@property RTUserProfileViewController *viewController;
@property RTAccountSettingsWireframe *accountSettingsWireframe;

@end

@implementation RTUserProfileWireframe

- (instancetype)initWithViewController:(RTUserProfileViewController *)viewController
              accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.accountSettingsWireframe = accountSettingsWireframe;
    }
    return self;
}

- (void)presentUserProfileInterfaceForUsername:(NSString *)username {
    
}

- (void)presentAccountSettingsInterface {
    [self.accountSettingsWireframe presentAccountSettingsInterface];
}

@end
