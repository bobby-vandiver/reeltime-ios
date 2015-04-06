#import <Foundation/Foundation.h>
#import "RTClient.h"

@protocol RTBrowseUsersDataManagerDelegate <NSObject>

- (void)listUsersPage:(NSUInteger)page
           withClient:(RTClient *)client
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure;

@end
