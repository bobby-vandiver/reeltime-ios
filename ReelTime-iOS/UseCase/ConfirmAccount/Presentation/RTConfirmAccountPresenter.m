#import "RTConfirmAccountPresenter.h"
#import "RTConfirmAccountView.h"
#import "RTConfirmAccountInteractor.h"

@interface RTConfirmAccountPresenter ()

@property id<RTConfirmAccountView> view;
@property RTConfirmAccountInteractor *interactor;

@end

@implementation RTConfirmAccountPresenter

- (instancetype)initWithView:(id<RTConfirmAccountView>)view
                  interactor:(RTConfirmAccountInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedConfirmationEmail {
    [self.interactor sendConfirmationEmail];
}

- (void)requestedConfirmationWithCode:(NSString *)code {
    [self.interactor confirmAccountWithCode:code];
}

- (void)confirmationEmailSent {
    
}

- (void)confirmationEmailFailedWithErrors:(NSArray *)errors {
    
}

- (void)confirmAccountSucceeded {
    
}

- (void)confirmAccountFailedWithErrors:(NSArray *)errors {
    
}

@end
