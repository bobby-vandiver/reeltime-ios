#import <Foundation/Foundation.h>

@protocol RTLoginDataManagerDelegate <NSObject>

- (void)loginDataOperationFailedWithError:(NSError *)error;

@end
