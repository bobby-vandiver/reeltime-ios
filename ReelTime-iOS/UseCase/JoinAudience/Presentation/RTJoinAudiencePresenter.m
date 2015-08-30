#import "RTJoinAudiencePresenter.h"

#import "RTJoinAudienceView.h"
#import "RTJoinAudienceInteractor.h"
#import "RTJoinAudienceError.h"

#import "RTLogging.h"

@interface RTJoinAudiencePresenter ()

@property id<RTJoinAudienceView> view;
@property RTJoinAudienceInteractor *interactor;

@end

@implementation RTJoinAudiencePresenter

- (instancetype)initWithView:(id<RTJoinAudienceView>)view
                  interactor:(RTJoinAudienceInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedAudienceMembershipForReelId:(NSNumber *)reelId {
    [self.interactor joinAudienceForReelId:reelId];
}

- (void)joinAudienceSucceededForReelId:(NSNumber *)reelId {
    [self.view showAudienceAsJoinedForReelId:reelId];
}

- (void)joinAudienceFailedForReelId:(NSNumber *)reelId
                          withError:(NSError *)error {

    NSString *const unknownErrorMessage = @"Unknown error occurred while joining audience. Please try again.";
    
    if ([error.domain isEqual:RTJoinAudienceErrorDomain]) {
        NSInteger code = error.code;
        
        if (code == RTJoinAudienceErrorReelNotFound) {
            [self.view showErrorMessage:@"Cannot join audience of an unknown reel!"];
        }
        else if (code == RTJoinAudienceErrorUnknownError) {
            [self.view showErrorMessage:unknownErrorMessage];
        }
    }
    else {
        DDLogWarn(@"Encountered an error outside the %@ domain = %@", RTJoinAudienceErrorDomain, error);
        [self.view showErrorMessage:unknownErrorMessage];
    }
}

@end
