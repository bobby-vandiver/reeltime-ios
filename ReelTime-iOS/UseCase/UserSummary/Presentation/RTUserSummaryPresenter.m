#import "RTUserSummaryPresenter.h"
#import "RTUserSummaryView.h"
#import "RTUserSummaryInteractor.h"

#import "RTUserSummaryError.h"

#import "RTUser.h"
#import "RTUserDescription.h"

#import "RTLogging.h"

@interface RTUserSummaryPresenter ()

@property id<RTUserSummaryView> view;
@property RTUserSummaryInteractor *interactor;

@end

@implementation RTUserSummaryPresenter

- (instancetype)initWithView:(id<RTUserSummaryView>)view
                  interactor:(RTUserSummaryInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedSummaryForUsername:(NSString *)username {
    [self.interactor summaryForUsername:username];
}

- (void)retrievedUser:(RTUser *)user {
    RTUserDescription *description = [RTUserDescription userDescriptionWithForUsername:user.username
                                                                       withDisplayName:user.displayName
                                                                     numberOfFollowers:user.numberOfFollowers
                                                                     numberOfFollowees:user.numberOfFollowees
                                                                    numberOfReelsOwned:user.numberOfReelsOwned
                                                           numberOfAudienceMemberships:user.numberOfAudienceMemberships
                                                                currentUserIsFollowing:user.currentUserIsFollowing];
    [self.view showUserDescription:description];
}

- (void)failedToRetrieveUserWithError:(NSError *)error {
    BOOL isUserSummaryError = [error.domain isEqualToString:RTUserSummaryErrorDomain];
    
    if (isUserSummaryError) {
        if (error.code == RTUserSummaryErrorUserNotFound) {
            [self.view showUserNotFoundMessage:@"The requested user could not be found at this time"];
        }
        else {
            DDLogWarn(@"Failed to retrieve user with unhandled user summary error: %@", error);
        }
    }
    else {
        DDLogWarn(@"Failed to retrieve user with unexpected error: %@", error);
    }
}

@end
