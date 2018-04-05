//////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) since 1999. VASCO DATA SECURITY
//  All rights reserved. http://www.vasco.com
//
//////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "QRCodeScannerSDKDelegate.h"


@class QRCodeScannerSDKViewController;

static const NSString * QRCODESCANNERSDK_VERSION= @"4.15.4";

/**
 * This class provide methods for QRCode scannning
 */
@interface QRCodeScannerSDKViewController : UIViewController


/**
 * Instantiate the QRCodeScanner viewController
 * You should consider to use the method with a scanner overlay, as it provides better performance and user experience.
 * @param delegate The delegate that implement QRCodeScannerSDKDelegate protocol.
 * @param vibrate To enable / disable vibration when QRCode is detected
 * @param image Image for the cancel button. If null, no cancel button will be displayed.
 * @param codeType the type of code to scan : QR_CODE(1) or CRONTO_CODE(2) or ALL_CODE(3)
 * @throws QRCodeScannerSDKException If an error occurs when initializing the object.<br/>
 * The exception can contain one of the following error codes: 
 * <ul>
 *  <li>QRCodeScannerSDKErrorCodes_INTERNAL_ERROR if an internal error occurs (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QRCodeScannerSDKErrorCodes_INPUT_PARAMETER_NULL if the input parameter is null (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QRCodeScannerSDKErrorCodes_CAMERA_NOT_AVAILABLE if no camera is available to perform the scanning process (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QRCodeScannerSDKErrorCodes_PERMISSION_DENIED if no camera is available to perform the scanning process (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QQRCodeScannerSDKErrorCodes_PERMISSION_DENIED if the permission to access to the camera is denied.</li>
 * </ul>
*/
- (id)initWithDelegate:(id<QRCodeScannerSDKDelegate>)delegate
               vibrate:(BOOL)vibrate codeType: (int) codeType  useImage:(UIImage *)image;

/**
 * Instantiate the QRCodeScanner viewController with an overlay to facilitate scanning.
 * This method should be use for better performance and user convenience.
 * @param delegate The delegate that implement QRCodeScannerSDKDelegate protocol.
 * @param vibrate To enable / disable vibration when QRCode is detected
 * @param image Image for the cancel button. If null, no cancel button will be displayed.
 * @param codeType the type of code to scan : QR_CODE(1) or CRONTO_CODE(2) or ALL_CODE(3)
 * @param scannerOverlay To enable / disable the scanner overlay.
 * @param color UIColor to define the overlay color. If nil the default color (0x99000000) is used.
 * @throws QRCodeScannerSDKException If an error occurs when initializing the object.<br/>
 * The exception can contain one of the following error codes:
 * <ul>
 *  <li>QRCodeScannerSDKErrorCodes_INTERNAL_ERROR if an internal error occurs (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QRCodeScannerSDKErrorCodes_INPUT_PARAMETER_NULL if the input parameter is null (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QRCodeScannerSDKErrorCodes_CAMERA_NOT_AVAILABLE if no camera is available to perform the scanning process (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QRCodeScannerSDKErrorCodes_PERMISSION_DENIED if no camera is available to perform the scanning process (see QRCodeScannerSDKErrorCodes.h).</li>
 *  <li>QQRCodeScannerSDKErrorCodes_PERMISSION_DENIED if the permission to access to the camera is denied.</li>
 * </ul>
 */
- (id)initWithDelegate:(id<QRCodeScannerSDKDelegate>)delegate
               vibrate:(BOOL)vibrate codeType: (int) codeType  useImage:(UIImage *)image
        scannerOverlay:(BOOL)scannerOverlay scannerOverlayColor:(UIColor *)color;

@end

/*!
 * \mainpage Image Scanner SDK API - Programmer documentation
 * \brief Provides the entry points of the Image SDK framework API:
 * <ul>
 *  <li>Instantiate a QRCodeScannerSDKViewController giving a pointer to the QRCodeScannerSDKDelegate and vibration option.</li>
 *  <li>Delegate must be implemented according the QRCodeScannerSDKDelegate protocol.</li>
 * </ul>
 * Copyright &copy; since 1999. VASCO DATA SECURITY. All Rights Reserved.
 * @version 4.15.4
 */

