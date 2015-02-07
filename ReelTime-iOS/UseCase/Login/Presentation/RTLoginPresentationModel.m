#import "RTLoginPresentationModel.h"

@implementation RTLoginPresentationModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.unknownErrorOccurred = [RTConditionalMessage falseWithMessage:nil];
        self.validUsername = [RTConditionalMessage trueWithMessage:nil];
        self.validPassword = [RTConditionalMessage trueWithMessage:nil];
        self.validCredentials = [RTConditionalMessage trueWithMessage:nil];
    }
    return self;
}

@end
