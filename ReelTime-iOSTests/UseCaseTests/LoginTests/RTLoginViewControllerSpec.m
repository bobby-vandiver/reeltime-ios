#import "RTTestCommon.h"

#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"

SpecBegin(RTLoginViewController)

describe(@"login view controller", ^{

    __block RTLoginViewController *viewController;
    __block RTLoginPresenter *presenter;
    
    __block UITextField *usernameField;
    __block UITextField *passwordField;
    
    beforeEach(^{
        usernameField = [[UITextField alloc] init];
        passwordField = [[UITextField alloc] init];
        
        presenter = mock([RTLoginPresenter class]);
        viewController = [RTLoginViewController viewControllerWithPresenter:presenter];
       
        viewController.usernameField = usernameField;
        viewController.passwordField = passwordField;
    });
    
    describe(@"when login button is pressed", ^{
        it(@"should request login for the supplied username and password fields", ^{
            viewController.usernameField.text = username;
            viewController.passwordField.text = password;
            
            [viewController pressedLoginButton];
            [verify(presenter) requestedLoginWithUsername:username password:password];
        });
    });
    
    describe(@"when register button is pressed", ^{
        it(@"should request account registration be presented", ^{
            [viewController pressedRegisterButton];
            [verify(presenter) requestedAccountRegistration];
        });
    });
});

SpecEnd