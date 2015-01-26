#import "EXPMatchers+beError.h"

EXPMatcherImplementationBegin(beError, (NSString *expectedDomain, NSInteger expectedCode)) {
    
    BOOL actualIsNil = (actual == nil);
    BOOL actualIsError = [actual isKindOfClass:[NSError class]];

    BOOL expectedDomainIsNil = (expectedDomain == nil);
    
    __block NSError *actualError;
    __block NSString *actualDomain;
    __block NSInteger actualCode;
    
    __block BOOL sameDomain;
    __block BOOL sameCode;
    
    prerequisite(^BOOL {
        return !(actualIsNil || expectedDomainIsNil);
    });
    
    match(^BOOL {
        if (!actualIsError) {
            return NO;
        }
        actualError = (NSError *)actual;
        
        actualDomain = actualError.domain;
        actualCode = actualError.code;
        
        sameDomain = [actualError.domain isEqualToString:expectedDomain];
        sameCode = (actualError.code == expectedCode);
        
        return (sameDomain && sameCode);
    });
    
    failureMessageForTo(^NSString * {
        if (actualIsNil) {
            return @"the actual value is nil/null";
        }
        if (expectedDomainIsNil) {
            return @"the expected domain is nil/null";
        }
        if (!actualIsError) {
            return [NSString stringWithFormat:@"expected: a kind of %@,"
                    "got: an instance of %@, which is not a kind of %@",
                    [NSError class], [actual class], [NSError class]];
        }
        if (!sameDomain) {
            return [NSString stringWithFormat:@"expected: error domain %@, got: error domain %@",
                    expectedDomain, actualDomain];
        }
        
        return [NSString stringWithFormat:@"expected: error code %ld, got: error code %ld",
                (long)expectedCode, (long)actualCode];
    });
    
    failureMessageForNotTo(^NSString * {
        if (actualIsNil) {
            return @"the actual value is nil/null";
        }
        if (expectedDomainIsNil) {
            return @"the expected domain is nil/null";
        }
        if (actualIsError) {
            return [NSString stringWithFormat:@"expected: not a kind of %@,"
                    "got: an instance of %@, which is a kind of %@",
                    [NSError class], [actual class], [NSError class]];
        }
        if (sameDomain) {
            return [NSString stringWithFormat:@"expected: not error domain %@, got: error domain %@",
                    expectedDomain, actualDomain];
        }
        
        return [NSString stringWithFormat:@"expected: not error code %ld, got: error code %ld",
                (long)expectedCode, (long)actualCode];
        
    });
}
EXPMatcherImplementationEnd