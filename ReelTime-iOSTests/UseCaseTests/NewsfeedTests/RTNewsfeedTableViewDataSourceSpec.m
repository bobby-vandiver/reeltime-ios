#import "RTTestCommon.h"

#import "RTNewsfeedTableViewDataSource.h"
#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

SpecBegin(RTNewsfeedTableViewDataSource)

describe(@"newsfeed table view data source", ^{
    
    __block RTNewsfeedTableViewDataSource *dataSource;
    __block UITableView *tableView;
    
    const NSInteger section = 0;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        dataSource = [[RTNewsfeedTableViewDataSource alloc] init];
    });
    
    describe(@"adding activities", ^{
        __block RTActivity *activity;
        __block RTActivity *sameActivity;
        
        beforeEach(^{
            RTUser *user1 = [[RTUser alloc] initWithUsername:username
                                                displayName:displayName
                                          numberOfFollowers:@(1)
                                          numberOfFollowees:@(2)];
            
            RTReel *reel1 = [[RTReel alloc] initWithReelId:@(3)
                                                     name:@"something"
                                             audienceSize:@(4)
                                           numberOfVideos:@(5)];
            
            activity = [RTActivity createReelActivityWithUser:user1 reel:reel1];
            
            RTUser *user2 = [[RTUser alloc] initWithUsername:username
                                                 displayName:displayName
                                           numberOfFollowers:@(1)
                                           numberOfFollowees:@(2)];
            
            RTReel *reel2 = [[RTReel alloc] initWithReelId:@(3)
                                                      name:@"something"
                                              audienceSize:@(4)
                                            numberOfVideos:@(5)];
            
            sameActivity = [RTActivity createReelActivityWithUser:user2 reel:reel2];
        });
        
        it(@"should be initalized with no activities", ^{
            NSInteger numberOfRows = [dataSource tableView:tableView numberOfRowsInSection:section];
            expect(numberOfRows).to.equal(0);
        });
        
        it(@"should include rows for each activity", ^{
            [dataSource addActivity:activity];
            
            NSInteger numberOfRows = [dataSource tableView:tableView numberOfRowsInSection:section];
            expect(numberOfRows).to.equal(1);
        });
        
        // TODO: Enable after isEqual and hash have been implemented
        xit(@"should not allow the same activity to be added multiple times", ^{
            [dataSource addActivity:activity];
            [dataSource addActivity:sameActivity];
            
            NSInteger numberOfRows = [dataSource tableView:tableView numberOfRowsInSection:section];
            expect(numberOfRows).to.equal(1);
        });
    });
});

SpecEnd
