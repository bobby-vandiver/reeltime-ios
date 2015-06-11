#import <Foundation/Foundation.h>

@protocol RTRevokeClientInteractorDelegate <NSObject>

- (void)clientRevocationSucceededForClientWithClientId:(NSString *)clientId;

- (void)clientRevocationFailedForClientWithClientId:(NSString *)clientId
                                             errors:(NSArray *)errors;

@end
