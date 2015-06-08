#import <Foundation/Foundation.h>

@protocol RTRevokeClientInteractorDelegate;
@class RTRevokeClientDataManager;

@interface RTRevokeClientInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTRevokeClientInteractorDelegate>)delegate
                     dataManager:(RTRevokeClientDataManager *)dataManager;

- (void)revokeClientWithClientId:(NSString *)clientId;

@end
