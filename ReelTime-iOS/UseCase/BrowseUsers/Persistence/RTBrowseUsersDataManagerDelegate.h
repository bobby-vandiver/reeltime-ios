#import <Foundation/Foundation.h>
#import "RTAPIClient.h"

@protocol RTBrowseUsersDataManagerDelegate <NSObject>

- (void)listUsersPage:(NSUInteger)page
           withClient:(RTAPIClient *)client
              success:(UserListCallback)success
              failure:(ServerErrorsCallback)failure;

@end
