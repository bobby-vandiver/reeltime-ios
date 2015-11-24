#import "RTRemoveAccountPresenter.h"
#import "RTRemoveAccountView.h"

#import "RTRemoveAccountInteractor.h"
#import "RTRemoveAccountWireframe.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTRemoveAccountErrorCodeToErrorMessageMapping.h"

#import "RTRemoveAccountError.h"
#import "RTLogging.h"

@interface RTRemoveAccountPresenter ()

@property id<RTRemoveAccountView> view;

@property RTRemoveAccountInteractor *interactor;
@property RTRemoveAccountWireframe *wireframe;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTRemoveAccountPresenter

- (instancetype)initWithView:(id<RTRemoveAccountView>)view
                  interactor:(RTRemoveAccountInteractor *)interactor
                   wireframe:(RTRemoveAccountWireframe *)wireframe {

    self = [super init];
    if (self) {
        self.view = view;
        
        self.interactor = interactor;
        self.wireframe = wireframe;
        
        RTRemoveAccountErrorCodeToErrorMessageMapping *mapping = [[RTRemoveAccountErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedAccountRemoval {
    [self.interactor removeAccount];
}

- (void)removeAccountSucceeded {
    [self.wireframe presentPostRemoveAccountInterface];
}

- (void)removeAccountFailedWithError:(NSError *)error {
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
