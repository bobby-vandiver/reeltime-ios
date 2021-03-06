#import "RTTestCommon.h"

#import "RTConfirmAccountViewController.h"
#import "RTConfirmAccountPresenter.h"

SpecBegin(RTConfirmAccountViewController)

describe(@"confirm account view controller", ^{
    
    __block RTConfirmAccountViewController *viewController;
    __block RTConfirmAccountPresenter *presenter;

    __block UITextField *confirmationCodeField;
 
    beforeEach(^{
        presenter = mock([RTConfirmAccountPresenter class]);
        viewController = [RTConfirmAccountViewController viewControllerWithPresenter:presenter];
        
        confirmationCodeField = [[UITextField alloc] init];
        viewController.confirmationCodeField = confirmationCodeField;
    });
    
    describe(@"when view will appear", ^{
        it(@"should reset fields", ^{
            confirmationCodeField.text = confirmationCode;
            
            [viewController viewWillAppear:anything()];
            expect(confirmationCodeField.text).to.equal(BLANK);
        });
    });
    
    describe(@"when the send email button is pressed", ^{
        it(@"should notify the presenter to send the email", ^{
            [viewController pressedSendEmailButton];
            [verify(presenter) requestedConfirmationEmail];
        });
    });
    
    describe(@"when the confirm button is pressed", ^{
        it(@"should pass the confirmation code to the presenter", ^{
            viewController.confirmationCodeField.text = confirmationCode;
            
            [viewController pressedConfirmButton];
            [verify(presenter) requestedConfirmationWithCode:confirmationCode];
        });
    });
});

SpecEnd