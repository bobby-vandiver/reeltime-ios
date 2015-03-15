#import "RTBrowseViewController.h"

#import "RTBrowseUsersView.h"
#import "RTBrowseReelsView.h"
#import "RTBrowseVideosView.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTBrowseViewController ()

@property RTBrowseUsersPresenter *usersPresenter;
@property RTBrowseReelsPresenter *reelsPresenter;
@property RTBrowseVideosPresenter *videosPresenter;

@end

@implementation RTBrowseViewController

+ (RTBrowseViewController *)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter
                                              reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                                             videosPresenter:(RTBrowseVideosPresenter *)videosPresenter {
    NSString *identifier = [RTBrowseViewController storyboardIdentifier];
    RTBrowseViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.usersPresenter = usersPresenter;
        controller.reelsPresenter = reelsPresenter;
        controller.videosPresenter = videosPresenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Browse View Controller";
}

- (void)showUserMessage:(RTUserMessage *)message {
    
}

- (void)clearUserMessages {
    
}

- (void)showReelMessage:(RTReelMessage *)message {
    
}

- (void)clearReelMessages {
    
}

- (void)showVideoMessage:(RTVideoMessage *)message {
    
}

- (void)clearVideoMessages {
    
}

@end
