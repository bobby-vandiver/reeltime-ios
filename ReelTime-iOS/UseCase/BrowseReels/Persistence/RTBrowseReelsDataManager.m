#import "RTBrowseReelsDataManager.h"
#import "RTClient.h"

#import "RTReelList.h"
#import "RTLogging.h"

@implementation RTBrowseReelsDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *))callback {
    
    ReelListCallback successCallback = ^(RTReelList *reelList) {
        callback(reelList.reels);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to retrieve reel list: %@", serverErrors);
        callback(@[]);
    };
    
    [self.client listReelsPage:page
                       success:successCallback
                       failure:failureCallback];
}

@end
