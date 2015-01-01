#import "RTTestCommon.h"

#import "RTLoginPresenter.h"
#import "RTLoginView.h"
#import "RTLoginInteractor.h"

SpecBegin(RTLoginPresenter)

describe(@"login presenter", ^{
    
    __block RTLoginPresenter *presenter;
    
    __block RTLoginInteractor *interactor;
    __block id<RTLoginView> view;
    
    __block NSString *username;
    __block NSString *password;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTLoginView));
        interactor = mock([RTLoginInteractor class]);
        
        presenter = [[RTLoginPresenter alloc] initWithView:view
                                                interactor:interactor];
        
        username = @"someone";
        password = @"secret";
    });
    
    describe(@"login requested", ^{
        it(@"should fail when username is missing", ^{
            [presenter requestedLoginWithUsername:@"" password:password];
            [verify(view) showErrorMessage:@"Username is required"];
        });
        
        it(@"should fail when password is missing", ^{
            [presenter requestedLoginWithUsername:username password:@""];
            [verify(view) showErrorMessage:@"Password is required"];
        });
        
        it(@"should pass credentials to interactor", ^{
            [presenter requestedLoginWithUsername:username password:password];
            [verify(interactor) loginWithUsername:username password:password];
        });
    });
    
});

SpecEnd
