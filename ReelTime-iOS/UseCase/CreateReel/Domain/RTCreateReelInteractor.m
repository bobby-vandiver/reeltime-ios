#import "RTCreateReelInteractor.h"

#import "RTCreateReelInteractorDelegate.h"
#import "RTCreateReelDataManager.h"

#import "RTCreateReelError.h"
#import "RTErrorFactory.h"

static const NSInteger MinimumNameLength = 3;
static const NSInteger MaximumNameLength = 25;

@interface RTCreateReelInteractor ()

@property id<RTCreateReelInteractorDelegate> delegate;
@property RTCreateReelDataManager *dataManager;

@end

@implementation RTCreateReelInteractor

- (instancetype)initWithDelegate:(id<RTCreateReelInteractorDelegate>)delegate
                     dataManager:(RTCreateReelDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)createReelWithName:(NSString *)name {
    
    NSError *error;
    BOOL valid = [self validateName:name error:&error];
    
    if (valid) {
        [self.dataManager createReelForName:name
                                    success:[self createReelSuccessCallbackForName:name]
                                    failure:[self createReelFailureCallbackForName:name]];
    }
    else {
        [self.delegate createReelFailedForName:name withError:error];
    }
}

- (BOOL)validateName:(NSString *)name
               error:(NSError *__autoreleasing *)error {
    NSError *nameError;
    
    if (name == nil || name.length == 0) {
        nameError = [RTErrorFactory createReelErrorWithCode:RTCreateReelErrorMissingReelName];
    }
    else if (name.length < MinimumNameLength || name.length > MaximumNameLength) {
        nameError = [RTErrorFactory createReelErrorWithCode:RTCreateReelErrorInvalidReelName];
    }

    if (nameError && error) {
        *error = nameError;
    }

    return nameError == nil;
}

- (NoArgsCallback)createReelSuccessCallbackForName:(NSString *)name {
    return ^{
        [self.delegate createReelSucceededForName:name];
    };
}

- (ErrorCallback)createReelFailureCallbackForName:(NSString *)name {
    return ^(NSError *error) {
        [self.delegate createReelFailedForName:name withError:error];
    };
}

@end
