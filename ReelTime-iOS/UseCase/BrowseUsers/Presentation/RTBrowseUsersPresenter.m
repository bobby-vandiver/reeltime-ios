#import "RTBrowseUsersPresenter.h"

#import "RTBrowseUsersView.h"
#import "RTUserWireframe.h"

#import "RTUser.h"
#import "RTUserMessage.h"

@interface RTBrowseUsersPresenter ()

@property id<RTBrowseUsersView> view;
@property id<RTUserWireframe> wireframe;

@end

@implementation RTBrowseUsersPresenter

- (instancetype)initWithView:(id<RTBrowseUsersView>)view
                  interactor:(RTPagedListInteractor *)interactor
                   wireframe:(id<RTUserWireframe>)wireframe {
    self = [super initWithDelegate:self interactor:interactor];
    if (self) {
        self.view = view;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)clearPresentedItems {
    [self.view clearMessages];
}

// TODO: Determine what the text should say
- (void)presentItem:(RTUser *)user {
    RTUserMessage *message = [RTUserMessage userMessageWithText:user.displayName
                                                    forUsername:user.username];
    [self.view showUserMessage:message];
}

- (void)requestedUserDetailsForUsername:(NSString *)username {
    [self.wireframe presentUserForUsername:username];
}

@end
