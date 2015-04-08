#import "RTUserSummaryInteractor.h"
#import "RTUserSummaryInteractorDelegate.h"
#import "RTUserSummaryDataManager.h"

#import "RTUserSummaryError.h"
#import "RTErrorFactory.h"

@interface RTUserSummaryInteractor ()

@property id<RTUserSummaryInteractorDelegate> delegate;
@property RTUserSummaryDataManager *dataManager;

@end

@implementation RTUserSummaryInteractor

- (instancetype)initWithDelegate:(id<RTUserSummaryInteractorDelegate>)delegate
                     dataManager:(RTUserSummaryDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)summaryForUsername:(NSString *)username {
    if (username.length > 0) {
        id callback = ^(RTUser *user) {
            [self.delegate retrievedUser:user];
        };
        
        [self.dataManager fetchUserForUsername:username
                                      callback:callback];
    }
    else {
        [self notifyDelegateOfErrorWithCode:RTUserSummaryErrorMissingUsername];
    }
}

- (void)userNotFound {
    [self notifyDelegateOfErrorWithCode:RTUserSummaryErrorUserNotFound];
}

- (void)notifyDelegateOfErrorWithCode:(RTUserSummaryError)code {
    NSError *error = [RTErrorFactory userSummaryErrorWithCode:code];
    [self.delegate failedToRetrieveUserWithError:error];
}

@end
