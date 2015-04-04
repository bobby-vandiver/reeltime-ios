#import <Foundation/Foundation.h>
#import "RTClient.h"

@protocol RTBrowseReelsDataManagerDelegate <NSObject>

- (void)listReelsPage:(NSUInteger)page
           withClient:(RTClient *)client
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure;

@end
