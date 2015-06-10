#import <Foundation/Foundation.h>

@protocol RTRevokeClientInteractorDelegate <NSObject>

- (void)clientRevocationSucceededForClientWithClientId:(NSString *)clientId;

- (void)clientRevocationFailedWithErrors:(NSArray *)errors;

@end
