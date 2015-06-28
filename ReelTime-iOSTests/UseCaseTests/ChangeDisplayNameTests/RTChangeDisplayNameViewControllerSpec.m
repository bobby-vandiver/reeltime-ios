#import "RTTestCommon.h"

#import "RTChangeDisplayNameViewController.h"
#import "RTChangeDisplayNamePresenter.h"

SpecBegin(RTChangeDisplayNameViewController)

describe(@"change display name view controller", ^{
    
    __block RTChangeDisplayNameViewController *viewController;
    __block RTChangeDisplayNamePresenter *presenter;
    
    __block UITextField *displayNameField;
    
    beforeEach(^{
        presenter = mock([RTChangeDisplayNamePresenter class]);
        viewController = [RTChangeDisplayNameViewController viewControllerWithPresenter:presenter];
        
        displayNameField = [[UITextField alloc] init];
        viewController.displayNameField = displayNameField;
    });
    
    describe(@"when view will appear", ^{
        it(@"should reset fields", ^{
            displayNameField.text = displayName;

            [viewController viewWillAppear:anything()];
            expect(displayNameField.text).to.equal(BLANK);
        });
    });
    
    describe(@"when save button is pressed", ^{
        it(@"should request display name change with new name", ^{
            viewController.displayNameField.text = displayName;
            
            [viewController pressedSaveButton];
            [verify(presenter) requestedDisplayNameChangeWithDisplayName:displayName];
        });
    });
});

SpecEnd