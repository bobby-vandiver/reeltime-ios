#import <Foundation/Foundation.h>

@protocol RTRevokeClientInteractorDelegate;
@class RTRevokeClientDataManager;
@class RTCurrentUserService;

@interface RTRevokeClientInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTRevokeClientInteractorDelegate>)delegate
                     dataManager:(RTRevokeClientDataManager *)dataManager
              currentUserService:(RTCurrentUserService *)currentUserService;

- (void)revokeClientWithClientId:(NSString *)clientId;

@end
