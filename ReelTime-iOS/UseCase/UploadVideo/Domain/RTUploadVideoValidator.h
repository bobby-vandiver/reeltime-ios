#import "RTValidator.h"

@interface RTUploadVideoValidator : RTValidator

- (BOOL)validateVideo:(NSURL *)videoUrl
            thumbnail:(NSURL *)thumbnailUrl
           videoTitle:(NSString *)videoTitle
             reelName:(NSString *)reelName
               errors:(NSArray *__autoreleasing *)errors;

@end
