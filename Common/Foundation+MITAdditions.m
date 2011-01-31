#import "Foundation+MITAdditions.h"

@implementation NSURL (MITAdditions)

+ (NSURL *)internalURLWithModuleTag:(NSString *)tag path:(NSString *)path {
    return [NSURL internalURLWithModuleTag:tag path:path query:nil];
}

+ (NSURL *)internalURLWithModuleTag:(NSString *)tag path:(NSString *)path query:(NSString *)query {
    if ([path rangeOfString:@"/"].location != 0) {
        path = [NSString stringWithFormat:@"/%@", path];
    }
    if ([query length] > 0) {
        path = [path stringByAppendingFormat:@"?%@", query];
    }
    NSURL *url = [[NSURL alloc] initWithScheme:MITInternalURLScheme host:tag path:path];
    return [url autorelease];
}

@end

@implementation NSMutableString (MITAdditions)

- (void)replaceOccurrencesOfStrings:(NSArray *)targets withStrings:(NSArray *)replacements options:(NSStringCompareOptions)options {
    assert([targets count] == [replacements count]);
    NSInteger i = 0;
    for (NSString *target in targets) {
        [self replaceOccurrencesOfString:target withString:[replacements objectAtIndex:i] options:options range:NSMakeRange(0, [self length])];
        i++;
    }
}

@end

@implementation NSString (MITAdditions)

- (NSInteger)lengthOfLineWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    NSMutableString *mutableString = [NSMutableString string];
    NSArray *lines = [self componentsSeparatedByString:@"\n"];
    if (lines.count > 0) {
        NSString *line = [lines objectAtIndex:0];
        NSArray *words = [line componentsSeparatedByString:@" "];
        NSInteger count = words.count;
        if (count > 0) {
            NSInteger index = 0;
            [mutableString appendString:[words objectAtIndex:index]];
            CGSize fullSize = [mutableString sizeWithFont:font];
            index++;
            while (index < count && fullSize.width < size.width) {
                [mutableString appendString:[NSString stringWithFormat:@" %@", [words objectAtIndex:index]]];
                fullSize = [mutableString sizeWithFont:font];
                index++;
            }
        }
    }
    return [mutableString length];
}

- (NSString *)substringToMaxIndex:(NSUInteger)to {
	NSUInteger maxLength = [self length] - 1;
	return [self substringToIndex:(to > maxLength) ? maxLength : to];
}

@end