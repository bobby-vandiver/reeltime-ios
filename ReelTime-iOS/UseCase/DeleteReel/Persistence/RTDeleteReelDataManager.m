#import "RTDeleteReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTDeleteReelServerErrorMapping.h"

@interface RTDeleteReelDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTDeleteReelDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTDeleteReelServerErrorMapping *mapping = [[RTDeleteReelServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)deleteReelWithReelId:(NSUInteger)reelId
                     success:(NoArgsCallback)success
                     failure:(ErrorCallback)failure {
    
    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client deleteReelForReelId:reelId
                             success:successCallback
                             failure:failureCallback];
}


@end
