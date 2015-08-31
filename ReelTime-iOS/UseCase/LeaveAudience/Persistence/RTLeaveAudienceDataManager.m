#import "RTLeaveAudienceDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTLeaveAudienceServerErrorMapping.h"

@interface RTLeaveAudienceDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTLeaveAudienceDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTLeaveAudienceServerErrorMapping *mapping = [[RTLeaveAudienceServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)requestAudienceLeaveForReelId:(NSNumber *)reelId
                         leaveSuccess:(NoArgsCallback)leaveSuccess
                         leaveFailure:(ErrorCallback)leaveFailure {
    
    NoArgsCallback successCallback = ^{
        leaveSuccess();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        leaveFailure(error);
    };
 
    [self.client leaveAudienceForReelWithReelId:[reelId integerValue]
                                        success:successCallback
                                        failure:failureCallback];
}

@end
