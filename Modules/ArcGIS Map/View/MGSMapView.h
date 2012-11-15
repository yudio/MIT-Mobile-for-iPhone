#import <UIKit/UIKit.h>
#import "MGSMapViewDelegate.h"

@class MGSMapCoordinate;
@class MGSMapAnnotation;
@class MGSMapQuery;
@class MGSMapLayer;
@class MGSQueryLayer;

@interface MGSMapView : UIView
#pragma mark - Basemap Management
@property (nonatomic, strong) NSString *activeBasemap;
@property (nonatomic, strong, readonly) NSSet *availableBasemaps;

@property (nonatomic, readonly) NSArray *allLayers;
@property (nonatomic, readonly) NSArray *visibleLayers;

@property (nonatomic) BOOL showUserLocation;
@property (nonatomic,assign) id<MGSMapViewDelegate> mapViewDelegate;
@property (nonatomic,readonly,strong) MGSMapLayer *defaultLayer;

#pragma mark - Layer Management
- (NSString*)nameForBasemapWithIdentifier:(NSString*)basemapIdentifier;
- (BOOL)addLayer:(MGSMapLayer*)layer withIdentifier:(NSString*)layerIdentifier;
- (BOOL)insertLayer:(MGSMapLayer*)layer atIndex:(NSUInteger)layerIndex withIdentifier:(NSString*)layerIdentifier;
- (MGSMapLayer*)layerWithIdentifier:(NSString*)layerIdentifier;
- (BOOL)containsLayerWithIdentifier:(NSString*)layerIdentifier;
- (void)removeLayerWithIdentifier:(NSString*)layerIdentifier;

- (void)centerOnAnnotation:(MGSMapAnnotation*)annotation;

- (BOOL)isLayerHidden:(NSString*)layerIdentifier;
- (void)setHidden:(BOOL)hidden forLayerIdentifier:(NSString*)layerIdentifier;

#pragma mark - Callouts
- (void)showCalloutForAnnotation:(MGSMapAnnotation*)annotation;
- (void)showCalloutWithView:(UIView*)view
              forAnnotation:(MGSMapAnnotation*)annotation;
- (void)hideCallout;

@end