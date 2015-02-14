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
        self.nextPage = INITIAL_PAGE_NUMBER;
    }
    return self;
}

- (void)requestedNextNewsfeedPage {
    [self.interactor newsfeedPage:self.nextPage++];
}

- (void)requestedNewsfeedReset {
    self.nextPage = INITIAL_PAGE_NUMBER;
    [self.view clearMessages];
}

- (void)retrievedNewsfeed:(RTNewsfeed *)newsfeed {
    for (RTActivity *activity in newsfeed.activities) {
        RTStringWithEmbeddedLinks *message = [self.messageSource messageForActivity:activity];
        RTActivityType type = [activity.type integerValue];
        [self.view showMessage:message forActivityType:type];
    }
}

- (void)failedToRetrieveNewsfeedWithError:(NSError *)error {
    // TODO: Log error or inform user if appropriate
}

@end
