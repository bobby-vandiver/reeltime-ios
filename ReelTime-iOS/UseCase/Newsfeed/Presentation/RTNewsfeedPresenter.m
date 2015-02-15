#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedWireframe.h"
#import "RTNewsfeedMessageSource.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

#import "RTStringWithEmbeddedLinks.h"

static const NSUInteger INITIAL_PAGE_NUMBER = 1;

@interface RTNewsfeedPresenter ()

@property id<RTNewsfeedView> view;
@property RTNewsfeedInteractor *interactor;
@property (weak) RTNewsfeedWireframe *wireframe;
@property RTNewsfeedMessageSource *messageSource;

@property NSUInteger nextPage;
@property NSMutableArray *activities;

@end

@implementation RTNewsfeedPresenter

- (instancetype)initWithView:(id<RTNewsfeedView>)view
                  interactor:(RTNewsfeedInteractor *)interactor
                   wireframe:(RTNewsfeedWireframe *)wireframe
               messageSource:(RTNewsfeedMessageSource *)messageSource {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
        self.messageSource = messageSource;

        [self resetActivites];
    }
    return self;
}

- (void)resetActivites {
    self.nextPage = INITIAL_PAGE_NUMBER;
    self.activities = [NSMutableArray array];
}

- (void)requestedNextNewsfeedPage {
    [self.interactor newsfeedPage:self.nextPage++];
}

- (void)requestedNewsfeedReset {
    [self resetActivites];
    [self.view clearMessages];
}

- (void)retrievedNewsfeed:(RTNewsfeed *)newsfeed {
    for (RTActivity *activity in newsfeed.activities) {
        if (![self.activities containsObject:activity]) {
            [self showActivity:activity];
            [self.activities addObject:activity];
        }
    }
}

- (void)showActivity:(RTActivity *)activity {
    RTStringWithEmbeddedLinks *message = [self.messageSource messageForActivity:activity];
    RTActivityType type = [activity.type integerValue];
    
    [self.view showMessage:message forActivityType:type];
}

- (void)failedToRetrieveNewsfeedWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

@end
