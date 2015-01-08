#import "RTLoginInteractor.h"

@interface RTLoginInteractor (RTLoginDataManagerDelegate)

- (void)didSetLoggedInUser;

- (void)loginDataOperationFailedWithError:(NSError *)error;

@end
