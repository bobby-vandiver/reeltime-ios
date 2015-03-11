#import "RTNewsfeedDataManager.h"

#import "RTClient.h"

#import "RTNewsfeed.h"
#import "RTServerErrors.h"

@implementation RTNewsfeedDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(id listPage))callback {
    
    // TODO: Ensure listPage is instance of RTNewsfeed

    NewsfeedCallback successCallback = ^(RTNewsfeed *newsfeed) {
        callback(newsfeed);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *errors) {
        // TODO: Log errors
        RTNewsfeed *newsfeed = [[RTNewsfeed alloc] init];
        newsfeed.activities = [NSArray array];

        callback(newsfeed);
    };
    
    [self.client newsfeedPage:page
                      success:successCallback
                      failure:failureCallback];
}

@end
