#import "RTChangeDisplayNamePresenter.h"
#import "RTChangeDisplayNameView.h"
#import "RTChangeDisplayNameInteractor.h"

@interface RTChangeDisplayNamePresenter ()

@property id<RTChangeDisplayNameView> view;
@property RTChangeDisplayNameInteractor *interactor;

@end

@implementation RTChangeDisplayNamePresenter

- (instancetype)initWithView:(id<RTChangeDisplayNameView>)view
                  interactor:(RTChangeDisplayNameInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedDisplayNameChangeWithDisplayName:(NSString *)displayName {
    [self.interactor changeDisplayName:displayName];
}

- (void)changeDisplayNameSucceeded {
    [self.view showMessage:@"Display name change succeeded"];
}

- (void)changeDisplayNameFailedWithErrors:(NSArray *)errors {
    
}

@end
