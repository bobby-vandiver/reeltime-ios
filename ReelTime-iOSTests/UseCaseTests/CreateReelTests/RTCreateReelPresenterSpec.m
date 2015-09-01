#import "RTTestCommon.h"

#import "RTCreateReelPresenter.h"

#import "RTCreateReelView.h"
#import "RTCreateReelInteractor.h"

#import "RTCreateReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTCreateReelPresenter)

describe(@"create reel presenter", ^{
    
    __block RTCreateReelPresenter *presenter;

    __block id<RTCreateReelView> view;
    __block RTCreateReelInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTCreateReelView));
        interactor = mock([RTCreateReelInteractor class]);
        
        presenter = [[RTCreateReelPresenter alloc] initWithView:view
                                                     interactor:interactor];
    });
    
    describe(@"requested reel creation", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedReelCreationForName:reelName];
            [verify(interactor) createReelWithName:reelName];
        });
    });
    
    describe(@"reel creation succeeded", ^{
        it(@"should show reel as being created", ^{
            [presenter createReelSucceededForName:reelName];
            [verify(view) showCreatedReelWithName:reelName];
        });
    });
    
    describe(@"reel creation failed", ^{
        it(@"reel name errors are shown as validation errors", ^{
            NSDictionary *mapping = @{
                                      @(RTCreateReelErrorMissingReelName):
                                          @"Reel name is required",
                                      @(RTCreateReelErrorInvalidReelName):
                                          @"Reel name must be 3 to 25 characters",
                                      @(RTCreateReelErrorReservedReelName):
                                          @"Reel name is reserved",
                                      @(RTCreateReelErrorReelNameIsUnavailable):
                                          @"Reel name is unavailable"
                                      };
            
            for (NSNumber *key in mapping.allKeys) {
                [verify(view) reset];
                
                NSError *error = [RTErrorFactory createReelErrorWithCode:[key integerValue]];
                [presenter createReelFailedForName:reelName withError:error];
                
                NSString *message = mapping[key];
                [verify(view) showValidationErrorMessage:message forField:RTCreateReelViewFieldReelName];
            }
        });
        
        it(@"unknown error is shown as an error message", ^{
            NSError *error = [RTErrorFactory createReelErrorWithCode:RTCreateReelErrorUnknownError];
            
            [presenter createReelFailedForName:reelName withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while creating reel. Please try again."];
        });
    });
});

SpecEnd
