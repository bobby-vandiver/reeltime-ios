#import "RTTestCommon.h"

#import "RTUploadVideoInteractor.h"
#import "RTUploadVideoInteractorDelegate.h"

#import "RTUploadVideoDataManager.h"
#import "RTUploadVideoValidator.h"

#import "RTErrorFactory.h"
#import "RTUploadVideoError.h"

#import "RTVideo.h"

SpecBegin(RTUploadVideoInteractor)

describe(@"upload video interactor", ^{
    
    __block RTUploadVideoInteractor *interactor;
    __block id<RTUploadVideoInteractorDelegate> delegate;
    
    __block RTUploadVideoDataManager *dataManager;
    __block RTUploadVideoValidator *validator;
    
    __block NSURL *videoUrl;
    __block NSURL *thumbnailUrl;
    
    __block MKTArgumentCaptor *callbackCaptor;
    __block MKTArgumentCaptor *errorCaptor;
    
    beforeEach(^{
        validator = mock([RTUploadVideoValidator class]);
        dataManager = mock([RTUploadVideoDataManager class]);
        
        delegate = mockProtocol(@protocol(RTUploadVideoInteractorDelegate));
        interactor = [[RTUploadVideoInteractor alloc] initWithDelegate:delegate
                                                           dataManager:dataManager
                                                             validator:validator];
        
        videoUrl = mock([NSURL class]);
        thumbnailUrl = mock([NSURL class]);
        
        callbackCaptor = [[MKTArgumentCaptor alloc] init];
        errorCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"uploading video", ^{
        void (^givenValid)(BOOL) = ^(BOOL valid) {
            id invoke = given([validator validateVideo:videoUrl thumbnail:thumbnailUrl videoTitle:videoTitle reelName:reelName errors:nil]);
            [[invoke withMatcher:anything() forArgument:4] willReturnBool:valid];
        };
        
        it(@"validation errors", ^{
            givenValid(NO);

            [interactor uploadVideo:videoUrl thumbnail:thumbnailUrl withVideoTitle:videoTitle toReelWithName:reelName];
            [verify(delegate) uploadFailedWithErrors:anything()];
        });
        
        it(@"should forward data manager errors to delegate", ^{
            givenValid(YES);

            [interactor uploadVideo:videoUrl thumbnail:thumbnailUrl withVideoTitle:videoTitle toReelWithName:reelName];
            
            [verify(dataManager) uploadVideo:videoUrl
                                   thumbnail:thumbnailUrl
                                   withTitle:videoTitle
                                      toReel:reelName
                                     success:anything()
                                     failure:[callbackCaptor capture]];
            
            [verifyCount(delegate, never()) uploadFailedWithErrors:anything()];
            
            ArrayCallback callback = [callbackCaptor value];
            NSError *error = [RTErrorFactory uploadVideoErrorWithCode:RTUploadVideoErrorInvalidVideo];
            
            callback(@[error]);
            [verify(delegate) uploadFailedWithErrors:[errorCaptor capture]];
            
            NSArray *errors = [errorCaptor value];
            expect(errors).to.haveACountOf(1);
            expect(errors[0]).to.equal(error);
        });
        
        it(@"successful upload", ^{
            givenValid(YES);
            
            [interactor uploadVideo:videoUrl thumbnail:thumbnailUrl withVideoTitle:videoTitle toReelWithName:reelName];
            
            [verify(dataManager) uploadVideo:videoUrl
                                   thumbnail:thumbnailUrl
                                   withTitle:videoTitle
                                      toReel:reelName
                                     success:[callbackCaptor capture]
                                     failure:anything()];
            
            [verifyCount(delegate, never()) uploadSucceededForVideo:anything()];
            
            RTVideo *video = mock([RTVideo class]);
            VideoCallback callback = [callbackCaptor value];

            callback(video);
            [verify(delegate) uploadSucceededForVideo:video];
        });
    });
});

SpecEnd
