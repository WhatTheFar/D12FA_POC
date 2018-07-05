import com.vasco.digipass.sdk.DigipassSDK
import com.vasco.digipass.sdk.DigipassSDKConstants
import com.vasco.digipass.sdk.DigipassSDKReturnCodes
import com.vasco.digipass.sdk.responses.ActivationResponse
import com.vasco.digipass.sdk.utils.utilities.UtilitiesSDK


class OTP {
    companion object {
        val staticVectorStr = "380800B2010356445302101010101010101010232323232323232303010104010605010606010007010008010409010F0A01010B01010C01010E01000F0100100101112F120100130101140101150C4D4F4233305F5445524F202016010117044000E8051801002901082A01002B01002C01021141120100130101140102150C4D4F4233305F5445534720201601011704400BE8D51801032901082A01002B01002C01021901001A01001B0100210110220110230110"
        val serialNumber = "VDS1001110"
        val activationCode = "05855706670412143648251147810340074099788"

        //server password is used for encrypt data in server only. not important.
        private const val serverPassword = "AX2E43"

        fun genActivation(): ActivationResponse? {
            val dynamicVector: ByteArray? = null
            val activateResponse = DigipassSDK.activateOfflineWithFingerprint(staticVectorStr, serialNumber, activationCode, null, null, serverPassword, null, dynamicVector);

            if (activateResponse.getReturnCode() != DigipassSDKReturnCodes.SUCCESS) {
                System.out.println("Offline activation with fingerprint FAILED - [ " + activateResponse.getReturnCode()
                        + ": " + DigipassSDK.getMessageForReturnCode(activateResponse.getReturnCode()) + " ]");
                return null
            } else {
                System.out.println("Offline activation with fingerprint SUCCEEDED");
                return activateResponse
            }
        }

        fun genOTP(): String {
            var dynamicVector: ByteArray? = null
            var staticVector: ByteArray? = null

            val activateResponse = DigipassSDK.activateOfflineWithFingerprint(staticVectorStr, serialNumber, activationCode, null, null, serverPassword, null, dynamicVector);

            if (activateResponse.getReturnCode() != DigipassSDKReturnCodes.SUCCESS) {
                System.out.println("Offline activation with fingerprint FAILED - [ " + activateResponse.getReturnCode()
                        + ": " + DigipassSDK.getMessageForReturnCode(activateResponse.getReturnCode()) + " ]");
            } else {
                dynamicVector = activateResponse.getDynamicVector()
                staticVector = activateResponse.getStaticVector()
                //getProperties(staticVector, dynamicVector)
                System.out.println("Offline activation with fingerprint SUCCEEDED");

            }

            val generateResponse = DigipassSDK.generateResponseOnly(staticVector, dynamicVector, serverPassword, 0, DigipassSDKConstants.CRYPTO_APPLICATION_INDEX_APP_1, null)

            if (generateResponse.getReturnCode() != DigipassSDKReturnCodes.SUCCESS) {
                System.out.println("OTP generation has FAILED - [ " + generateResponse.getReturnCode() + ": "
                        + DigipassSDK.getMessageForReturnCode(generateResponse.getReturnCode()) + " ]")
            } else {
                val otp = generateResponse.getResponse()

                System.out.println("OTP generated: " + otp)

            }

            return generateResponse.response
        }

        fun getProperties(staticVector: ByteArray?, dynamicVector: ByteArray?) {
            val propertyResponse = DigipassSDK.getDigipassProperties(staticVector, dynamicVector);

            if (propertyResponse.getReturnCode() != DigipassSDKReturnCodes.SUCCESS) {
                System.out.println("Get digipass property FAILED - [ " + propertyResponse.getReturnCode() + ": "
                        + DigipassSDK.getMessageForReturnCode(propertyResponse.getReturnCode()) + " ]\n");
            } else {
                System.out.println("Get digipass properties SUCCEEDED \n");

                // Display DIGIPASS properties
                System.out.println("Static vector version: " + propertyResponse.getVersion());
                System.out.println("Status: " + propertyResponse.getStatus());
                System.out.println("Serial number: " + propertyResponse.getSerialNumber());

                System.out.println("Password mandatory: " + propertyResponse.isPasswordMandatory());
                System.out.println("Password protected: " + propertyResponse.isPasswordProtected());
                System.out.println("Password Min Length value: " + propertyResponse.getPasswordMinLength());
                System.out.println("Password Max Length value: " + propertyResponse.getPasswordMaxLength());
                System.out.println("Weak password control: " + propertyResponse.isWeakPasswordControl());
                System.out.println("Password check level: " + propertyResponse.getPasswordCheckLevel());
                System.out.println("Password fatal: " + propertyResponse.getPasswordFatal());
                System.out.println("Password penalty counter: " + propertyResponse.getPasswordFatalCounter());
                System.out.println("Penalty reset action: " + propertyResponse.isPenaltyResetAction());

                System.out.println("Token derivation supported: " + propertyResponse.isTokenDerivationSupported());

                System.out.println("High security mode: " + propertyResponse.isHighSecurity());
                System.out.println("DP+ high security mode: " + propertyResponse.isDpPlusHighSecurity());

                System.out.println("Activation code format hexadecimal: " + propertyResponse.isActivationCodeFormatHexa());
                System.out.println("Activation code checksum: " + propertyResponse.isUseChecksumForActivationCode());
                System.out.println("Number of cryptographic applications: " + propertyResponse.getApplications().size);
                System.out.println("UTC time: " + propertyResponse.getUtcTime());

                System.out.println("Storage version: " + propertyResponse.getStorageVersion());
                System.out.println("Secret derivation: " + propertyResponse.isUseSecretDerivation());
                System.out.println("Master key: " + UtilitiesSDK.bytesToHexa(propertyResponse.getMasterKey()));

                System.out.println("Iteration power: " + propertyResponse.getIterationPower());
                System.out.println("Creation version: " + propertyResponse.getCreationVersion());
                System.out.println("Token derivation activated: " + propertyResponse.isTokenDerivationActivated());
                System.out.println("Password derivation activated: " + propertyResponse.isPasswordDerivationActivated());

                // Display applications properties
                for (i in 0 until propertyResponse.applications.size) {
                    val app = propertyResponse.getApplications()[i];

                    System.out.println("\n============================================\n");
                    System.out.println("Application index: " + app.getIndex());
                    System.out.println("Application name: " + app.getName());
                    System.out.println("CodeWord: " + UtilitiesSDK.bytesToHexa(app.getCodeword()));
                    System.out.println("Application enabled: " + app.isEnabled());

                    System.out.println("Event based: " + app.isEventBased());
                    System.out.println("Time based: " + app.isTimeBased());

                    System.out.println("Response length: " + app.getResponseLength());
                    System.out.println("Even counter: " + app.getEventCounter());
                    System.out.println("Time step: " + app.getTimeStep());
                    System.out.println("Last time used: " + app.getLastTimeUsed());
                    System.out.println("Host code length: " + app.getHostCodeLength());
                    System.out.println("Output Type: " + app.getOutputType());

                    // DataFields
                    val dtfsNumber = app.getDataFieldNumber();
                    System.out.println("Datafield number: " + dtfsNumber);

                    System.out.println("Check digit: " + app.isCheckDigit());
                    System.out.println("DIGIPASS+: " + app.isDpPlus());

                    System.out.println("Authentication mode: " + app.getAuthenticationMode());
                }
            }
        }

    }
}