#import "RTTestCommon.h"

#import "RTUploadVideoViewController.h"
#import "RTUploadVideoPresenter.h"

SpecBegin(RTUploadVideoViewController)

describe(@"upload video view controller", ^{
    
    __block RTUploadVideoViewController *viewController;
    __block RTUploadVideoPresenter *presenter;
    
    __block UITextField *videoTitleField;
    __block UITextField *reelNameField;
    
    __block NSURL *videoUrl;
    __block NSURL *thumbnailUrl;
    
    beforeEach(^{
        videoTitleField = [[UITextField alloc] init];
        reelNameField = [[UITextField alloc] init];
        
        presenter = mock([RTUploadVideoPresenter class]);
        viewController = [RTUploadVideoViewController viewControllerWithPresenter:presenter
                                                                         forVideo:videoUrl
                                                                        thumbnail:thumbnailUrl];
        
        viewController.videoTitleField = videoTitleField;
        viewController.reelNameField = reelNameField;
    });
    
    context(@"populated form", ^{
        beforeEach(^{
            videoTitleField.text = videoTitle;
            reelNameField.text = reelName;
        });

        describe(@"when view will appear", ^{
            it(@"should reset fields", ^{
                [viewController viewWillAppear:anything()];
                
                expect(videoTitleField.text).to.equal(BLANK);
                expect(reelNameField.text).to.equal(BLANK);
            });
        });
        
        describe(@"when submit button is pressed", ^{
            it(@"should request upload from presenter", ^{
                [viewController pressedSubmitButton];

                [verify(presenter) requestedUploadForVideo:videoUrl
                                             withThumbnail:thumbnailUrl
                                                videoTitle:videoTitle
                                            toReelWithName:reelName];
            });
        });
    });
});

SpecEnd
