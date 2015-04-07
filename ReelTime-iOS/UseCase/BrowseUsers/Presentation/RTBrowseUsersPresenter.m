#import "RTBrowseUsersPresenter.h"

#import "RTBrowseUsersView.h"
#import "RTUserWireframe.h"

#import "RTUser.h"
#import "RTUserDescription.h"

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
    [self.view clearUserDescriptions];
}

- (void)presentItem:(RTUser *)user {
    RTUserDescription *description = [RTUserDescription userDescriptionWithDisplayName:user.displayName
                                                                           forUsername:user.username];
    [self.view showUserDescription:description];
}

- (void)requestedUserDetailsForUsername:(NSString *)username {
    [self.wireframe presentUserForUsername:username];
}

@end
