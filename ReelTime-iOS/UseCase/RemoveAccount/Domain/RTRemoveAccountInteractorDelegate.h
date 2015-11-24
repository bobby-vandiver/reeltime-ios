#import <Foundation/Foundation.h>

@protocol RTRemoveAccountInteractorDelegate <NSObject>

- (void)removeAccountSucceeded;

- (void)removeAccountFailedWithError:(NSError *)error;

@end
