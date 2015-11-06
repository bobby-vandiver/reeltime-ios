#import "RTUploadVideoValidator.h"
#import "RTUploadVideoError.h"

#import "RTErrorFactory.h"

@implementation RTUploadVideoValidator

- (BOOL)validateVideo:(NSURL *)videoUrl
            thumbnail:(NSURL *)thumbnailUrl
           videoTitle:(NSString *)videoTitle
             reelName:(NSString *)reelName errors:(NSArray *__autoreleasing *)errors {
    
    return [super validateWithErrors:errors validationBlock:^(NSMutableArray *errorContainer) {
        [self validateVideo:videoUrl errors:errorContainer];
        [self validateThumbnail:thumbnailUrl errors:errorContainer];
        [self validateVideoTitle:videoTitle errors:errorContainer];
        [self validateReelName:reelName errors:errorContainer];
    }];
}

- (void)validateVideo:(NSURL *)videoUrl
               errors:(NSMutableArray *)errors {
    if (videoUrl == nil) {
        [self addUploadVideoErrorCode:RTUploadVideoErrorMissingVideo toErrors:errors];
    }
}

- (void)validateThumbnail:(NSURL *)thumbnail
                   errors:(NSMutableArray *)errors {
    if (thumbnail == nil) {
        [self addUploadVideoErrorCode:RTUploadVideoErrorMissingThumbnail toErrors:errors];
    }
}

- (void)validateVideoTitle:(NSString *)videoTitle
                    errors:(NSMutableArray *)errors {
    if (videoTitle.length == 0) {
        [self addUploadVideoErrorCode:RTUploadVideoErrorMissingVideoTitle toErrors:errors];
    }
}

- (void)validateReelName:(NSString *)reelName
                  errors:(NSMutableArray *)errors {
    if (reelName.length == 0) {
        [self addUploadVideoErrorCode:RTUploadVideoErrorMissingReelName toErrors:errors];
    }
}

- (void)addUploadVideoErrorCode:(RTUploadVideoError)code
                       toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory uploadVideoErrorWithCode:code];
    [errors addObject:error];
}

@end
