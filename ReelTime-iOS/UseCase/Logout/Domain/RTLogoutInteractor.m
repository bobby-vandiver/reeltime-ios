#import "RTLogoutInteractor.h"

#import "RTLogoutInteractorDelegate.h"
#import "RTLogoutDataManager.h"

@interface RTLogoutInteractor ()

@property id<RTLogoutInteractorDelegate> delegate;
@property RTLogoutDataManager *dataManager;

@end

@implementation RTLogoutInteractor

- (instancetype)initWithDelegate:(id<RTLogoutInteractorDelegate>)delegate
                     dataManager:(RTLogoutDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)logout {

}

@end
