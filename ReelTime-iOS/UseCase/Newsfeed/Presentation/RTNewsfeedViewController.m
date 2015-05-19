#import "RTNewsfeedViewController.h"

#import "RTNewsfeedPresenter.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTActivityType.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTActivityCell.h"
#import "RTActivityCell+ConfigureForRTActivityMessage.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

static NSString *const ActivityCellIdentifier = @"ActivityCell";

@interface RTNewsfeedViewController ()

@property RTNewsfeedPresenter *presenter;
@property RTMutableArrayDataSource *dataSource;

@end

@implementation RTNewsfeedViewController

+ (instancetype)viewControllerWithPresenter:(RTNewsfeedPresenter *)presenter {
    NSString *identifier = [RTNewsfeedViewController storyboardIdentifier];
    RTNewsfeedViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.presenter = presenter;
        controller.dataSource = [self createDataSourceWithPresenter:controller.presenter];
    }
    return controller;
}

+ (RTMutableArrayDataSource *)createDataSourceWithPresenter:(RTNewsfeedPresenter *)presenter {
    return [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                             cellIdentifier:ActivityCellIdentifier
                                         configureCellBlock:^(RTActivityCell *cell, RTActivityMessage *message) {
                                             [cell configureForActivityMessage:message withLabelDelegate:presenter];
                                         }];
}

+ (NSString *)storyboardIdentifier {
    return @"Newsfeed View Controller";
}

- (RTArrayDataSource *)tableViewDataSource {
    return self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[RTActivityCell class] forCellReuseIdentifier:ActivityCellIdentifier];
    [self.tableView setDataSource:self.dataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter requestedNextPage];
}

- (void)showMessage:(RTActivityMessage *)message {
    [self.dataSource addItem:message];
    [self.tableView reloadData];
}

- (void)clearMessages {
    [self.dataSource removeAllItems];
    [self.tableView reloadData];
}

@end
