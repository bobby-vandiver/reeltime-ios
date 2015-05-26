#import <Foundation/Foundation.h>

@protocol RTChangeDisplayNameInteractorDelegate <NSObject>

- (void)changeDisplayNameSucceeded;

- (void)changeDisplayNameFailedWithErrors:(NSArray *)errors;

@end
