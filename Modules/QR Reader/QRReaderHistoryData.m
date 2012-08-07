#import "QRReaderHistoryData.h"
#import "QRReaderResult.h"
#import "UIImage+Resize.h"
#import "CoreDataManager.h"
#import "UIKit+MITAdditions.h"

static QRReaderHistoryData *sharedHistoryData = nil;

@interface QRReaderHistoryData ()
@property (strong) NSMutableArray *mutableResults;
@end

@implementation QRReaderHistoryData
@synthesize mutableResults = _mutableResults;
@dynamic results;

- (id)init {
    self = [super init];
    if (self) {
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                     ascending:NO];
        self.mutableResults = [[[NSMutableArray alloc] initWithArray:[[CoreDataManager coreDataManager] objectsForEntity:QRReaderResultEntityName
                                                                                                      matchingPredicate:nil
                                                                                                        sortDescriptors:[NSArray arrayWithObject:descriptor]]] autorelease];
    }
    
    return self;
}

- (void)dealloc {
    self.mutableResults = nil;
    [super dealloc];
}

- (void)eraseAll {
    [[CoreDataManager coreDataManager] deleteObjects:self.results];
    [[CoreDataManager coreDataManager] saveData];
    [self.mutableResults removeAllObjects];
}

- (void)deleteScanResult:(QRReaderResult*)result {
    [[CoreDataManager coreDataManager] deleteObject:result];
    [[CoreDataManager coreDataManager] saveData];
    [self.mutableResults removeObject:result];
}

- (QRReaderResult*)insertScanResult:(NSString *)scanResult
                           withDate:(NSDate *)date {
    return [self insertScanResult:scanResult
                         withDate:date
                        withImage:nil];
}


- (QRReaderResult*)insertScanResult:(NSString*)scanResult
                           withDate:(NSDate*)date
                          withImage:(UIImage*)image
{
    return [self insertScanResult:scanResult
                         withDate:date
                        withImage:image
          shouldGenerateThumbnail:NO];
}

- (QRReaderResult*)insertScanResult:(NSString*)scanResult
                           withDate:(NSDate*)date
                          withImage:(UIImage*)image
            shouldGenerateThumbnail:(BOOL)generateThumbnail
{
    QRReaderResult *result = (QRReaderResult*)[[CoreDataManager coreDataManager] insertNewObjectForEntityForName:QRReaderResultEntityName];
    result.text = scanResult;
    result.date = date;
    
    if (image)
    {
        image = [[UIImage imageWithCGImage:image.CGImage
                                    scale:1.0
                              orientation:UIImageOrientationUp] imageByRotatingImageInRadians:-M_PI_2];
        
        result.scanImage = image;
        
        if (generateThumbnail)
        {
            result.thumbnail =  [image resizedImage:[QRReaderResult defaultThumbnailSize]
                               interpolationQuality:kCGInterpolationDefault];
        }
    }
    
    [[CoreDataManager coreDataManager] saveData];
    
    [self.mutableResults insertObject:result
                              atIndex:0];
    
    return result;
}

#pragma mark -
#pragma mark Dynamic Properties
- (NSArray*)results {
    return [NSArray arrayWithArray:self.mutableResults];
}

#pragma mark -
#pragma mark Singleton Implementation
+ (QRReaderHistoryData*)sharedHistory {
    if (sharedHistoryData == nil) {
        sharedHistoryData = [[super allocWithZone:NULL] init];
    }
    
    return sharedHistoryData;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedHistory] retain];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    return;
}

- (id)autorelease {
    return self;
}
@end
