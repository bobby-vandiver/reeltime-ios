#import <Foundation/Foundation.h>
#import "RTRevokeClientInteractorDelegate.h"

@protocol RTRevokeClientView;
@class RTRevokeClientInteractor;

@interface RTRevokeClientPresenter : NSObject <RTRevokeClientInteractorDelegate>

- (instancetype)initWithView:(id<RTRevokeClientView>)view
                  interactor:(RTRevokeClientInteractor *)interactor;

- (void)requestedRevocationForClientWithClientId:(NSString *)clientId;

@end
