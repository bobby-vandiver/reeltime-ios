#import "RTLeaveAudiencePresenter.h"

#import "RTLeaveAudienceView.h"
#import "RTLeaveAudienceInteractor.h"
#import "RTLeaveAudienceError.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTLeaveAudienceErrorCodeToErrorMessageMapping.h"

#import "RTLogging.h"

@interface RTLeaveAudiencePresenter ()

@property id<RTLeaveAudienceView> view;
@property RTLeaveAudienceInteractor *interactor;

@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTLeaveAudiencePresenter

- (instancetype)initWithView:(id<RTLeaveAudienceView>)view
                  interactor:(RTLeaveAudienceInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        
        RTLeaveAudienceErrorCodeToErrorMessageMapping *mapping = [[RTLeaveAudienceErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedAudienceMembershipLeaveForReelId:(NSNumber *)reelId {
    [self.interactor leaveAudienceForReelId:reelId];
}

- (void)leaveAudienceSucceededForReelId:(NSNumber *)reelId {
    [self.view showAudienceAsNotJoinedForReelId:reelId];
}

- (void)leaveAudienceFailedForReelId:(NSNumber *)reelId
                           withError:(NSError *)error {
    [self.errorPresenter presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    [self.view showErrorMessage:message];
}

@end
