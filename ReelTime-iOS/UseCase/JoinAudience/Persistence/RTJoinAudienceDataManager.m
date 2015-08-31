#import "RTJoinAudienceDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTJoinAudienceServerErrorMapping.h"

@interface RTJoinAudienceDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTJoinAudienceDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTJoinAudienceServerErrorMapping *mapping = [[RTJoinAudienceServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)requestAudienceMembershipForReelId:(NSNumber *)reelId
                               joinSuccess:(NoArgsCallback)success
                               joinFailure:(ErrorCallback)failure {
    
    NoArgsCallback successCallback = ^{
        success();
    };

    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client joinAudienceForReelWithReelId:[reelId integerValue]
                                       success:successCallback
                                       failure:failureCallback];
}

@end
