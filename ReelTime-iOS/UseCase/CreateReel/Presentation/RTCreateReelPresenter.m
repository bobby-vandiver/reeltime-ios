#import "RTCreateReelPresenter.h"

#import "RTCreateReelView.h"
#import "RTCreateReelInteractor.h"
#import "RTCreateReelError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTCreateReelErrorCodeToErrorMessageMapping.h"

@interface RTCreateReelPresenter ()

@property id<RTCreateReelView> view;
@property RTCreateReelInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTCreateReelPresenter

- (instancetype)initWithView:(id<RTCreateReelView>)view
                  interactor:(RTCreateReelInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTCreateReelErrorCodeToErrorMessageMapping *mapping = [[RTCreateReelErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedReelCreationForName:(NSString *)name {
    [self.interactor createReelWithName:name];
}

- (void)createReelSucceededForName:(NSString *)name {
    [self.view showCreatedReelWithName:name];
}

- (void)createReelFailedForName:(NSString *)name
                      withError:(NSError *)error {
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    switch (code) {
        case RTCreateReelErrorMissingReelName:
        case RTCreateReelErrorInvalidReelName:
        case RTCreateReelErrorReservedReelName:
        case RTCreateReelErrorReelNameIsUnavailable:
            [self.view showValidationErrorMessage:message forField:RTCreateReelViewFieldReelName];
            
        case RTCreateReelErrorUnknownError:
            [self.view showErrorMessage:message];
            break;
            
        default:
            break;
    }
}

@end
