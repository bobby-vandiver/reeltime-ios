#import <Foundation/Foundation.h>

@protocol RTAccountRegistrationDataManagerDelegate <NSObject>

- (void)accountRegistrationDataOperationFailedWithErrors:(NSArray *)errors;

@end
