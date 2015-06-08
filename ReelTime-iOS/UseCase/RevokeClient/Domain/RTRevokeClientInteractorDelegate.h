#import <Foundation/Foundation.h>

@protocol RTRevokeClientInteractorDelegate <NSObject>

- (void)clientRevocationSucceeded;

- (void)clientRevocationFailedWithErrors:(NSArray *)errors;

@end
