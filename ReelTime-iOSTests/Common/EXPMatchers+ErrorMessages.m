#import "EXPMatchers+ErrorMessages.h"

NSString *actualValueIsNil() {
    return @"the actual value is nil/null";
}

NSString *expectedValueIsNil(NSString *valueIdentifier) {
    return [NSString stringWithFormat:@"the expected %@ is nil/null", valueIdentifier];
}

NSString *actualIsClass(Class actualClass, Class expectedClass) {
    return [NSString stringWithFormat:@"expected: not a kind of %@,"
            "got: an instance of %@, which is a kind of %@",
            expectedClass, actualClass, expectedClass];
}

NSString *actualIsNotClass(Class actualClass, Class expectedClass) {
    return [NSString stringWithFormat:@"expected: a kind of %@,"
            "got: an instance of %@, which is not a kind of %@",
            expectedClass, actualClass, expectedClass];
}

NSString *actualIsExpected(NSString *valueIdentifier, id actual, id expected) {
    return [NSString stringWithFormat:@"expected: not %@ %@, got: %@ %@",
            valueIdentifier, expected, valueIdentifier, actual];
}

NSString *actualIsNotExpected(NSString *valueIdentifier, id actual, id expected) {
    return [NSString stringWithFormat:@"expected: %@ %@, got: %@ %@",
            valueIdentifier, expected, valueIdentifier, actual];
}
