#import <Foundation/Foundation.h>

@class RTUser;

@protocol RTUserSummaryInteractorDelegate <NSObject>

- (void)retrievedUser:(RTUser *)user;

- (void)failedToRetrieveUserWithError:(NSError *)error;

@end
