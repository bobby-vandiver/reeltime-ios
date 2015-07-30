#import "RTNewsfeedViewController.h"

#import "RTNewsfeedPresenter.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTActivityType.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTActivityMessage.h"
#import "RTActivityCell.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

static NSString *const ActivityCellIdentifier = @"ActivityCell";

@interface RTNewsfeedViewController ()

@property RTNewsfeedPresenter *newsfeedPresenter;
@property RTMutableArrayDataSource *activitiesDataSource;

@end

@implementation RTNewsfeedViewController

+ (instancetype)viewControllerWithPresenter:(RTNewsfeedPresenter *)presenter {
    NSString *identifier = [RTNewsfeedViewController storyboardIdentifier];
    RTNewsfeedViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.newsfeedPresenter = presenter;
        [controller createDataSource];
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Newsfeed View Controller";
}

- (void)createDataSource {
    ConfigureCellBlock configBlock = ^(RTActivityCell *cell, RTActivityMessage *message) {
        cell.textLabel.text = message.message.string;
    };
    
    self.activitiesDataSource = [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                                                  cellIdentifier:ActivityCellIdentifier
                                                              configureCellBlock:configBlock];
}

- (RTPagedListPresenter *)presenter {
    return self.newsfeedPresenter;
}

- (UITableView *)tableView {
    return self.activitiesTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self.activitiesDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter requestedNextPage];
}

- (void)showMessage:(RTActivityMessage *)message {
    [self.activitiesDataSource addItem:message];
    [self.tableView reloadData];
}

- (void)clearMessages {
    [self.activitiesDataSource removeAllItems];
    [self.tableView reloadData];
}

@end
