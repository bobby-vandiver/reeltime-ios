#import "RTNewsfeedDataManager.h"

#import "RTClient.h"

#import "RTNewsfeed.h"
#import "RTServerErrors.h"

@implementation RTNewsfeedDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *items))callback {
    
    // TODO: Ensure listPage is instance of RTNewsfeed

    NewsfeedCallback successCallback = ^(RTNewsfeed *newsfeed) {
        callback(newsfeed.activities);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *errors) {
        // TODO: Log errors
        callback(@[]);
    };
    
    [self.client newsfeedPage:page
                      success:successCallback
                      failure:failureCallback];
}

@end
