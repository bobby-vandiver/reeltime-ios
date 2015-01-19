#import "RTLoginInteractor.h"

@interface RTLoginInteractor (RTLoginDataManagerDelegate)

- (void)loginDataOperationFailedWithError:(NSError *)error;

@end
