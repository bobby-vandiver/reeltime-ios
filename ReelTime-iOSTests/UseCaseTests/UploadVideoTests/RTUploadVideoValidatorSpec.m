#import "RTTestCommon.h"

#import "RTUploadVideoValidator.h"
#import "RTUploadVideoError.h"

#import "RTErrorFactory.h"

SpecBegin(RTUploadVideoValidator)

describe(@"upload video validator", ^{
    
    __block RTUploadVideoValidator *validator;
    __block RTValidationTestHelper *helper;
    
    ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger errorCode) {
        return [RTErrorFactory uploadVideoErrorWithCode:errorCode];
    };
    
    ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
        NSString *videoUrlParam = parameters[VIDEO_URL_KEY];
        NSString *thumbnailUrlParam = parameters[THUMBNAIL_URL_KEY];
        NSString *videoTitleParam = parameters[VIDEO_TITLE_KEY];
        NSString *reelNameParam = parameters[REEL_NAME_KEY];

        NSURL *defaultVideoUrl = [NSURL URLWithString:@"file://tmp/video.mp4"];
        NSURL *defaultThumbnailUrl = [NSURL URLWithString:@"file://tmp/thumbnail.png"];
        
        BOOL valid = [validator validateVideo:getParameterOrDefault(videoUrlParam, defaultVideoUrl)
                                    thumbnail:getParameterOrDefault(thumbnailUrlParam, defaultThumbnailUrl)
                                   videoTitle:getParameterOrDefault(videoTitleParam, videoTitle)
                                     reelName:getParameterOrDefault(reelNameParam, reelName)
                                       errors:errors];
        
        return valid;
    };
    
    beforeEach(^{
        validator = [[RTUploadVideoValidator alloc] init];

        helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                       errorFactoryCallback:errorFactoryCallback];
    });
    
    it(@"missing video", ^{
        [helper expectErrorCodes:@[@(RTUploadVideoErrorMissingVideo)] forParameters:@{VIDEO_URL_KEY: null()}];
    });
    
    it(@"missing thumbnail", ^{
        [helper expectErrorCodes:@[@(RTUploadVideoErrorMissingThumbnail)] forParameters:@{THUMBNAIL_URL_KEY: null()}];
    });
    
    it(@"missing video title", ^{
        [helper expectErrorCodes:@[@(RTUploadVideoErrorMissingVideoTitle)] forParameters:@{VIDEO_TITLE_KEY: BLANK}];
        [helper expectErrorCodes:@[@(RTUploadVideoErrorMissingVideoTitle)] forParameters:@{VIDEO_TITLE_KEY: null()}];
    });
    
    it(@"missing reel name", ^{
        [helper expectErrorCodes:@[@(RTUploadVideoErrorMissingReelName)] forParameters:@{REEL_NAME_KEY: BLANK}];
        [helper expectErrorCodes:@[@(RTUploadVideoErrorMissingReelName)] forParameters:@{REEL_NAME_KEY: null()}];
    });
});

SpecEnd
