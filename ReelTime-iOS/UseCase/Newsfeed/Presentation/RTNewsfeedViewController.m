#import "RTNewsfeedViewController.h"

#import "RTNewsfeedPresenter.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTActivityType.h"

#import "RTArrayDataSource.h"
#import "RTActivityCell.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

static NSString *const CELL_IDENTIFIER = @"ActivityCell";

@interface RTNewsfeedViewController ()

@property RTNewsfeedPresenter *presenter;

@property RTArrayDataSource *dataSource;
@property NSMutableArray *messages;

@end

@implementation RTNewsfeedViewController

+ (RTNewsfeedViewController *)viewControllerWithPresenter:(RTNewsfeedPresenter *)presenter {
    NSString *identifier = [RTNewsfeedViewController storyboardIdentifier];
    RTNewsfeedViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Newsfeed View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initTableViewDataSource {
    self.dataSource = [[RTArrayDataSource alloc] initWithItems:self.messages cellIdentifier:CELL_IDENTIFIER configureCellBlock:^(RTActivityCell *cell, RTActivityMessage *message) {
    }];
}

- (void)showMessage:(RTActivityMessage *)message {
    
}

- (void)clearMessages {
    
}

@end
