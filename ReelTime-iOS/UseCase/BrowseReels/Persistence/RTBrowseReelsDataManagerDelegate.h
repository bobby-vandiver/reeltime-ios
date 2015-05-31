#import <Foundation/Foundation.h>
#import "RTAPIClient.h"

@protocol RTBrowseReelsDataManagerDelegate <NSObject>

- (void)listReelsPage:(NSUInteger)page
           withClient:(RTAPIClient *)client
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure;

@end
