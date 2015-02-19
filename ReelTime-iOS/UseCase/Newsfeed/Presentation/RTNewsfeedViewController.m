#import "RTNewsfeedViewController.h"

#import "RTNewsfeedPresenter.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTActivityType.h"

#import "RTArrayDataSource.h"

#import "RTActivityCell.h"
#import "RTActivityCell+ConfigureForRTActivityMessage.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

static NSString *const CELL_IDENTIFIER = @"ActivityCell";

@interface RTNewsfeedViewController ()

@property RTNewsfeedPresenter *presenter;

@property NSMutableArray *messages;
@property (readwrite) RTArrayDataSource *dataSource;

@end

@implementation RTNewsfeedViewController

+ (RTNewsfeedViewController *)viewControllerWithPresenter:(RTNewsfeedPresenter *)presenter {
    NSString *identifier = [RTNewsfeedViewController storyboardIdentifier];
    RTNewsfeedViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.presenter = presenter;
        controller.messages = [NSMutableArray array];
        controller.dataSource = [self createDataSourceWithMessages:controller.messages];
    }
    return controller;
}

+ (RTArrayDataSource *)createDataSourceWithMessages:(NSMutableArray *)messages {
    return [[RTArrayDataSource alloc] initWithItems:messages
                                     cellIdentifier:CELL_IDENTIFIER
                                 configureCellBlock:^(RTActivityCell *cell, RTActivityMessage *message) {
                                     [cell configureForActivityMessage:message];
                                 }];
}

+ (NSString *)storyboardIdentifier {
    return @"Newsfeed View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource:self.dataSource];
    [self.presenter requestedNextNewsfeedPage];
}

- (void)showMessage:(RTActivityMessage *)message {
    [self.messages addObject:message];
    [self.tableView reloadData];
}

- (void)clearMessages {
    [self.messages removeAllObjects];
    [self.tableView reloadData];
}

@end
