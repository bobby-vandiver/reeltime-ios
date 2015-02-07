#import <Foundation/Foundation.h>

@protocol RTLoginInteractorDelegate <NSObject>

- (void)loginSucceeded;

- (void)loginFailedWithErrors:(NSArray *)errors;

@end
