#import "RTLeaveAudiencePresenter.h"

#import "RTLeaveAudienceView.h"
#import "RTLeaveAudienceInteractor.h"
#import "RTLeaveAudienceError.h"

#import "RTLogging.h"

@interface RTLeaveAudiencePresenter ()

@property id<RTLeaveAudienceView> view;
@property RTLeaveAudienceInteractor *interactor;

@end

@implementation RTLeaveAudiencePresenter

- (instancetype)initWithView:(id<RTLeaveAudienceView>)view
                  interactor:(RTLeaveAudienceInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
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
    
    NSString *const unknownErrorMessage = @"Unknown error occurred while leaving audience. Please try again.";
    
    if ([error.domain isEqual:RTLeaveAudienceErrorDomain]) {
        NSInteger code = error.code;
        
        if (code == RTLeaveAudienceErrorReelNotFound) {
            [self.view showErrorMessage:@"Cannot leave audience of an unknown reel!"];
        }
        else if (code == RTLeaveAudienceErrorUnknownError) {
            [self.view showErrorMessage:unknownErrorMessage];
        }
    }
    else {
        DDLogWarn(@"Encountered an error outside the %@ domain = %@", RTLeaveAudienceErrorDomain, error);
        [self.view showErrorMessage:unknownErrorMessage];
    }
}

@end
