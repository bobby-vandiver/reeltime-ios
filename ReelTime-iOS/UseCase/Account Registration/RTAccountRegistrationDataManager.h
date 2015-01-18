#import <Foundation/Foundation.h>

@class RTAccountRegistrationInteractor;
@class RTClient;
@class RTClientCredentialsStore;

@interface RTAccountRegistrationDataManager : NSObject

- (instancetype)initWithInteractor:(RTAccountRegistrationInteractor *)interactor
                            client:(RTClient *)client
            clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

@end
