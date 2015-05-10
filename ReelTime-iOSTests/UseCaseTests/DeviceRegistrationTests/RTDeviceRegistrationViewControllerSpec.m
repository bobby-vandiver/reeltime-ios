#import "RTTestCommon.h"

#import "RTDeviceRegistrationViewController.h"
#import "RTDeviceRegistrationPresenter.h"

SpecBegin(RTDeviceRegistrationViewController)

describe(@"device registration view controller", ^{
    
    __block RTDeviceRegistrationViewController *viewController;
    __block RTDeviceRegistrationPresenter *presenter;
    
    __block UITextField *usernameField;
    __block UITextField *passwordField;
    __block UITextField *clientNameField;
    
    beforeEach(^{
        usernameField = [[UITextField alloc] init];
        passwordField = [[UITextField alloc] init];
        clientNameField = [[UITextField alloc] init];
        
        presenter = mock([RTDeviceRegistrationPresenter class]);
        viewController = [RTDeviceRegistrationViewController viewControllerWithPresenter:presenter];
        
        viewController.usernameField = usernameField;
        viewController.passwordField = passwordField;
        viewController.clientNameField = clientNameField;
    });
    
    describe(@"when register button is pressed", ^{
        it(@"should request device registration for the supplied information", ^{
            viewController.usernameField.text = username;
            viewController.passwordField.text = password;
            viewController.clientNameField.text = clientName;
            
            [viewController pressedRegisterButton];
            [verify(presenter) requestedDeviceRegistrationWithClientName:clientName username:username password:password];
        });
    });
});

SpecEnd