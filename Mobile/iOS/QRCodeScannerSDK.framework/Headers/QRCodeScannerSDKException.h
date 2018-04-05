//////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) since 1999. VASCO DATA SECURITY
//  All rights reserved. http://www.vasco.com
//
//////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

/**
 * This exception is thrown when a problem occurs while generating the device fingerprint.
 */
@interface QRCodeScannerSDKException : NSException
{
    
    int errorCode ;
    
    NSException * exception ;
    
}

/** The error code (Error codes are available on SecureStorageSDKErrorCodes.h) */
@property int errorCode ;

/** The exception if an internal error has been catched during the process */
@property (nonatomic , strong) NSException *exception ;

/**
 * Instanciate and init a QRCodeScannerSDKException
 */
-(id) initWithCause:(NSException *) c andError:(int) error ;

/**
 * Instanciate and init a QRCodeScannerSDKException
 */
-(id) initWithError:(int) error ;

@end

