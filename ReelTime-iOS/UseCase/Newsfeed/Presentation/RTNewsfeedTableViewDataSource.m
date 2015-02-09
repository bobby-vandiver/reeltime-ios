#import "RTNewsfeedTableViewDataSource.h"

#import "RTActivity.h"
#import "RTActivityCell.h"

@interface RTNewsfeedTableViewDataSource ()

@property NSMutableArray *activities;

@end

@implementation RTNewsfeedTableViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.activities = [NSMutableArray array];
    }
    return self;
}

- (void)addActivity:(RTActivity *)activity {
    if (![self.activities containsObject:activity]) {
        [self.activities addObject:activity];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
