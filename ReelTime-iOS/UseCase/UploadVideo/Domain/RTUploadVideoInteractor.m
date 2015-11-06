#import "RTUploadVideoInteractor.h"
#import "RTUploadVideoInteractorDelegate.h"

#import "RTUploadVideoDataManager.h"
#import "RTUploadVideoValidator.h"

@interface RTUploadVideoInteractor ()

@property (weak) id<RTUploadVideoInteractorDelegate> delegate;

@property RTUploadVideoDataManager *dataManager;
@property RTUploadVideoValidator *validator;

@end

@implementation RTUploadVideoInteractor

- (instancetype)initWithDelegate:(id<RTUploadVideoInteractorDelegate>)delegate
                     dataManager:(RTUploadVideoDataManager *)dataManager
                       validator:(RTUploadVideoValidator *)validator {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
        self.validator = validator;
    }
    return self;
}

- (void)uploadVideo:(NSURL *)videoUrl
          thumbnail:(NSURL *)thumbnailUrl
     withVideoTitle:(NSString *)videoTitle
     toReelWithName:(NSString *)reelName {
    
    NSArray *errors;
    BOOL valid = [self.validator validateVideo:videoUrl thumbnail:thumbnailUrl videoTitle:videoTitle reelName:reelName errors:&errors];
    
    if (!valid) {
        [self.delegate uploadFailedWithErrors:errors];
        return;
    }
    
    [self.dataManager uploadVideo:videoUrl
                        thumbnail:thumbnailUrl
                        withTitle:videoTitle
                           toReel:reelName
                          success:[self uploadVideoSuccessCallback]
                          failure:[self uploadVideoFailureCallback]];
}

- (VideoCallback)uploadVideoSuccessCallback {
    return ^(RTVideo *video) {
        [self.delegate uploadSucceededForVideo:video];
    };
}

- (ArrayCallback)uploadVideoFailureCallback {
    return ^(NSArray *errors) {
        [self.delegate uploadFailedWithErrors:errors];
    };
}

@end
