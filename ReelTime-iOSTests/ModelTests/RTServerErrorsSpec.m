#import "RTTestCommon.h"

#import "RTServerErrors.h"

SpecBegin(RTServerErrors)

describe(@"server errors", ^{
    
    __block RTServerErrors *serverErrors;
    
    beforeEach(^{
        serverErrors = [[RTServerErrors alloc] init];
    });
    
    describe(@"description", ^{
        it(@"has no errors", ^{
            serverErrors.errors = @[];
            expect(serverErrors.description).to.equal(@"errors(0): []");
        });
        
        it(@"has one error", ^{
            serverErrors.errors = @[@"first"];
            expect(serverErrors.description).to.equal(@"errors(1): [first]");
        });
        
        it(@"has multiple errors", ^{
            serverErrors.errors = @[@"first", @"second", @"third"];
            expect(serverErrors.description).to.equal(@"errors(3): [first, second, third]");
        });
    });
});

SpecEnd