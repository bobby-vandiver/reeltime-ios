#import "RTTestCommon.h"

#import "RTDeviceRegistrationInteractor.h"
#import "RTDeviceRegistrationInteractorDelegate.h"
#import "RTDeviceRegistrationDataManager.h"

#import "RTDeviceRegistrationError.h"

SpecBegin(RTDeviceRegistrationInteractor)

describe(@"device registration interactor", ^{
    
    __block RTDeviceRegistrationInteractor *interactor;

    __block id<RTDeviceRegistrationInteractorDelegate> delegate;
    __block RTDeviceRegistrationDataManager *dataManager;
    
    beforeEach(^{
        dataManager = mock([RTDeviceRegistrationDataManager class]);
        delegate = mockProtocol(@protocol(RTDeviceRegistrationInteractorDelegate));
        
        interactor = [[RTDeviceRegistrationInteractor alloc] initWithDelegate:delegate
                                                                  dataManager:dataManager];
    });
    
    describe(@"device registration requested", ^{
        
        context(@"missing parameters", ^{
            __block MKTArgumentCaptor *captor;
            
            beforeEach(^{
                captor = [[MKTArgumentCaptor alloc] init];
            });
            
            it(@"invalid client name", ^{
                [interactor registerDeviceWithClientName:BLANK username:username password:password];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(1);
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingClientName);
            });
            
            it(@"invalid username", ^{
                [interactor registerDeviceWithClientName:clientName username:BLANK password:password];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(1);
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingUsername);
            });
            
            it(@"invalid password", ^{
                [interactor registerDeviceWithClientName:clientName username:username password:BLANK];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(1);
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingPassword);
            });
            
            it(@"invalid client name, username and password", ^{
                [interactor registerDeviceWithClientName:BLANK username:BLANK password:BLANK];
                [verify(delegate) deviceRegistrationFailedWithErrors:[captor capture]];
                
                NSArray *errors = [captor value];
                expect(errors).to.haveACountOf(3);
                
                expect(errors[0]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingClientName);
                expect(errors[1]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingUsername);
                expect(errors[2]).to.beError(RTDeviceRegistrationErrorDomain, RTDeviceRegistrationErrorMissingPassword);
            });
        });
    });
});

SpecEnd