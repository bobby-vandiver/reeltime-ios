#import "EXPMatchers+beError.h"
#import "EXPMatchers+ErrorMessages.h"

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
            return actualValueIsNil();
        }
        if (expectedDomainIsNil) {
            return expectedValueIsNil(@"domain");
        }
        if (!actualIsError) {
            return actualIsNotClass([actual class], [NSError class]);
        }
        if (!sameDomain) {
            return actualIsNotExpected(@"error domain", actualDomain, expectedDomain);
        }
        
        return actualIsNotExpected(@"error code", @(actualCode), @(expectedCode));
    });
    
    failureMessageForNotTo(^NSString * {
        if (actualIsNil) {
            return actualValueIsNil();
        }
        if (expectedDomainIsNil) {
            return expectedValueIsNil(@"domain");
        }
        if (actualIsError) {
            return actualIsClass([actual class], [NSError class]);
        }
        if (sameDomain) {
            return actualIsExpected(@"error domain", actualDomain, expectedDomain);
        }
        
        return actualIsExpected(@"error code", @(actualCode), @(expectedCode));
    });
}
EXPMatcherImplementationEnd