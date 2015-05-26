#import "RTChangeDisplayNamePresenter.h"
#import "RTChangeDisplayNameView.h"
#import "RTChangeDisplayNameInteractor.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTChangeDisplayNameErrorCodeToErrorMessageMapping.h"

#import "RTChangeDisplayNameError.h"
#import "RTLogging.h"

@interface RTChangeDisplayNamePresenter ()

@property id<RTChangeDisplayNameView> view;
@property RTChangeDisplayNameInteractor *interactor;
@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTChangeDisplayNamePresenter

- (instancetype)initWithView:(id<RTChangeDisplayNameView>)view
                  interactor:(RTChangeDisplayNameInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTChangeDisplayNameErrorCodeToErrorMessageMapping *mapping = [[RTChangeDisplayNameErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
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
    [self.errorPresenter presentErrors:errors];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    switch (code) {
        case RTChangeDisplayNameErrorMissingDisplayName:
        case RTChangeDisplayNameErrorInvalidDisplayName:
            [self.view showValidationErrorMessage:message forField:RTChangeDisplayNameViewFieldDisplayName];
            break;
            
        default:
            DDLogWarn(@"Unknown change display name error code %ld", (long)code);
            break;
    }
}

@end
