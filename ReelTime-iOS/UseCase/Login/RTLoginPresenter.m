#import "RTLoginPresenter.h"

@interface RTLoginPresenter ()

@property id<RTLoginView> view;

@end

@implementation RTLoginPresenter

- (instancetype)initWithView:(id<RTLoginView>)view {
    self = [super init];
    if (self) {
        self.view = view;
    }
    return self;
}

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password {
    
}

- (void)loginSucceeded {
    
}

- (void)loginFailedWithError:(NSError *)error {
    
}

@end
