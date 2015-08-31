#import "RTDeleteVideoDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTDeleteVideoServerErrorMapping.h"

@interface RTDeleteVideoDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTDeleteVideoDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTDeleteVideoServerErrorMapping *mapping = [[RTDeleteVideoServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)deleteVideoForVideoId:(NSUInteger)videoId
                      success:(NoArgsCallback)success
                      failure:(ErrorCallback)failure {

    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client deleteVideoForVideoId:videoId
                               success:successCallback
                               failure:failureCallback];
}

@end
