#import "RTRevokeClientDataManager.h"

#import "RTAPIClient.h"
#import "RTServerErrorsConverter.h"

#import "RTRevokeClientServerErrorMapping.h"

@interface RTRevokeClientDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTRevokeClientDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTRevokeClientServerErrorMapping *mapping = [[RTRevokeClientServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)revokeClientWithClientId:(NSString *)clientId
               revocationSuccees:(NoArgsCallback)success
                         failure:(ArrayCallback)failure {
    
    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *revocationErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        failure(revocationErrors);
    };
    
    [self.client removeClientWithClientId:clientId
                                  success:successCallback
                                  failure:failureCallback];
}

@end
