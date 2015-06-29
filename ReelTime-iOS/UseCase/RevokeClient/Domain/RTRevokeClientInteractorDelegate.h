#import <Foundation/Foundation.h>

@protocol RTRevokeClientInteractorDelegate <NSObject>

- (void)clientRevocationSucceededForClientWithClientId:(NSString *)clientId
                                         currentClient:(BOOL)currentClient;

- (void)clientRevocationFailedForClientWithClientId:(NSString *)clientId
                                             errors:(NSArray *)errors;

@end
