//
//  RMUploadPreset+Private.h
//  RMUploadKit
//
//  Created by Keith Duncan on 31/07/2009.
//  Copyright 2009 Realmac Software. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#endif /* TARGET_OS_IPHONE */

#import "RMUploadKit/RMUploadPreset.h"

#import "RMUploadKit/RMUploadAvailability.h"

/*!
	\file
 */

/*!
	\brief
	Used to represent degrees.
*/
typedef CGFloat RMUploadDegrees;

/*!
	\struct
	Represents a geographic coordinate
	
	\field latitude
	The latitude in RMUploadDegrees.
	
	\field longitude
	The longitude in RMUploadDegrees.
*/
struct RMUploadGeographicCoordinate {
	RMUploadDegrees latitude;
	RMUploadDegrees longitude;
};
typedef struct RMUploadGeographicCoordinate RMUploadGeographicCoordinate;

/*!
	\brief
	Inline coordinate construction
 */
static inline RMUploadGeographicCoordinate RMUploadGeographicCoordinateMake(RMUploadDegrees latitude, RMUploadDegrees longitude) {
	RMUploadGeographicCoordinate coordinate;
	coordinate.latitude = latitude;
	coordinate.longitude = longitude;
	return coordinate;
}

/*!
	\brief
	
 */
extern BOOL RMUploadGeographicCoordinateEqualToCoordinate(RMUploadGeographicCoordinate coord1, RMUploadGeographicCoordinate coord2);

/*!
	\brief
	Used to represent no location.
 */
extern const RMUploadGeographicCoordinate RMUploadGeographicCoordinateUnknown;

/*
	Transform coordinates between types.
 */
extern NSString *RMUploadStringFromGeographicCoordinate(RMUploadGeographicCoordinate coordinate);
extern RMUploadGeographicCoordinate RMUploadGeographicCoordinateFromString(NSString *string);

/*!
	\brief
	This property is privately writable.
 */
extern NSString *const _RMUploadPresetAuthenticationKey;

/*!
	\brief
	This property is privately writable.
 */
extern NSString *const _RMUploadPresetPluginKey;

/*!
	\brief
	This property is privately writable for Dispatch import unarchiving.
 */
extern NSString *const _RMUploadPresetURIRepresentationKey;

@interface RMUploadPreset (/* RMPrivate */) <NSCopying>

/*!
	\brief
	An identifier for the preset.
 */
@property (readwrite, copy, nonatomic) NSURL *URIRepresentation;

@end

@interface RMUploadPreset (RMUploadPrivate)

/*!
	\brief
	The plug-in's bundle is used for the host in the returned `NSURL` object.
 */
+ (NSURL *)_generateURIRepresentationForPlugin:(RMUploadPlugin *)plugin;

/*
	\brief
	Name of the default thumbnail background icon.
 */
extern NSString *const _RMUploadKitPresetThumbnailBackgroundIconResourceName;

/*
	Thumbnail
 */
extern NSString *const _RMUploadPresetThumbnailIconResourceKey;
extern NSString *const _RMUploadPresetThumbnailBackgroundIconResourceKey;

/*
	Stamp
	returns thumbnail images by default
 */
extern NSString *const _RMUploadPresetStampIconResourceKey;
extern NSString *const _RMUploadPresetStampBackgroundIconResourceKey;

/*!
	\brief
	By default returns the +icon.
 */
+ (NSString *)_thumbnailIconResource;
/*!
	\brief
	Returns nil by default, if nil is returned no custom frill is being applied.
	If nil is returned, use [[NSBundle bundleWithIdentifier:RMUploadKitBundleIdentifier] imageForStyleImageResource:_RMUploadKitPresetThumbnailBackgroundIconResourceName]]
 */
+ (NSString *)_thumbnailBackgroundIconResource;

/*!
	\brief
	By default returns the +_thumbnailIcon.
 */
+ (NSString *)_stampIconResource;
/*!
	\brief
	If you override +stampIcon you should also override this.
	
	By default returns the +_thumbnailIconBackground.
 */
+ (NSString *)_stampBackgroundIconResource;

/*!
	\brief
	Used when displaying error views for your preset.
	
	\return
	nil by default, use RMUploadPluginsController for lookup with fallback
 */
+ (NSString *)_freestandingIconResource;

/*!
	\brief
	Presents a way to force any maps to display a particular location for the end point.
	
	\details
	This is as opposed to the default behaviour of using an IP lookup based on the DNS lookup of <tt>-[RMUploadPreset serviceURL]</tt>.
	The default implementation returns RMUploadGeographicCoordinateUnknown.
*/
- (RMUploadGeographicCoordinate)_endPointGeographicCoordinate;

@end
