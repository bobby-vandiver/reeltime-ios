#import "RTNewsfeedTableViewDataSource.h"

#import "RTActivity.h"
#import "RTActivityCell.h"

#import "NSMutableArray+AddUniqueObject.h"

@interface RTNewsfeedTableViewDataSource ()

@property NSMutableArray *activities;

@end

@implementation RTNewsfeedTableViewDataSource

- (instancetype)init {
    NSMutableArray *activities = [NSMutableArray array];
    
    self = [super initWithItems:activities cellIdentifier:@"TBD" configureCellBlock:^(id cell, id object) {
        // TODO: Invoke configureForActivity: on RTActivityCell
    }];
    
    if (self) {
        self.activities = activities;
    }
    return self;
}

- (void)addActivity:(RTActivity *)activity {
    [self.activities addUniqueObject:activity];
}

@end
