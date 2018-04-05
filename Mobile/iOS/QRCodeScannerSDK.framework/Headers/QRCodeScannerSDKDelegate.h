//////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) since 1999. VASCO DATA SECURITY
//  All rights reserved. http://www.vasco.com
//
//////////////////////////////////////////////////////////////////////////////

@class QRCodeScannerSDKViewController;
@class QRCodeScannerSDKException;

/**
 * Protocol definition to manage callback for result scanned, canceling and receive exception
 */
@protocol QRCodeScannerSDKDelegate 

	/**
     * Protocol QRCodeScannerSDKDelegate  method called when result is decoded
     * @param controller An object pointer to current QRCodeScannerSDKViewController sender
     * @param result The string decoded as NSString *
     * @param result The type of image scanned. Could be
     * <ul>
     *  <li>QRCodeScannerSDKConstants_QR_CODE if a QR Code image has been scanned (see QRCodeScannerSDKConstants.h).</li>
     *  <li>QRCodeScannerSDKConstants_CRONTO_CODE if a crontoSign image has been scanned (see QRCodeScannerSDKConstants.h).</li>
     * </ul>
     */
    - (void)qrCodeScannerSDKController:(QRCodeScannerSDKViewController*)controller didScanResult:(NSString *)result withCodeType:(int)codeType;

	/**
     * Protocol QRCodeScannerSDKDelegate  method called when the user touch on cancel button.
     * @param controller An object pointer to current QRCodeScannerSDKViewController sender
     */
	- (void)qrCodeScannerSDKControllerDidCancel:(QRCodeScannerSDKViewController*)controller;
	
	/**
     * Protocol QRCodeScannerSDKDelegate  method called when exceptions has occured
     * @param controller An object pointer to current QRCodeScannerSDKViewController sender
     * @param exception The exception<br/>
     * The exception can contain one of the following error codes: 
     * <ul>
     *  <li>QRCodeScannerSDKErrorCodes_INTERNAL_ERROR if an internal error occurs (see QRCodeScannerSDKErrorCodes.h).</li>
     * </ul>
     */
	- (void)qrCodeScannerSDKController:(QRCodeScannerSDKViewController*)controller threwException:(QRCodeScannerSDKException *)exception;

@end
