#import "RTPlayVideoViewController.h"
#import "RTStoryboardViewControllerFactory.h"

#import <MediaPlayer/MediaPlayer.h>

@interface RTPlayVideoViewController ()

@property (copy) NSNumber *videoId;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation RTPlayVideoViewController

+ (instancetype)viewControllerForVideoId:(NSNumber *)videoId {
    NSString *identifier = [RTPlayVideoViewController storyboardIdentifier];
    RTPlayVideoViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.videoId = videoId;
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Play Video View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playMovie];
}

- (void)playMovie {
    NSString *formatted = [NSString stringWithFormat:@"http://localhost:8080/reeltime/api/playlists/%@", self.videoId];
    NSURL *url = [NSURL URLWithString:formatted];
    
    MPMoviePlayerController *controller = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayerController = controller;
    
    controller.view.frame = self.view.bounds;
    
    [self.view addSubview:controller.view];
    [controller play];
}

@end
