package co.codium.d12fapoc.feature.main

import android.arch.lifecycle.MutableLiveData
import android.arch.lifecycle.ViewModel
import co.codium.d12fapoc.common.SingleLiveEvent
import com.vasco.digipass.sdk.DigipassSDK
import com.vasco.digipass.sdk.DigipassSDKConstants
import com.vasco.digipass.sdk.DigipassSDKReturnCodes
import javax.inject.Inject

class MainViewModel
@Inject constructor() : ViewModel() {

    private var staticVector: ByteArray? = null
    private var dynamicVector: ByteArray? = null

    val snackbarMessage: SingleLiveEvent<String> = SingleLiveEvent()

    val otpLiveData = MutableLiveData<String>()

    fun genOTP() {
        if (staticVector == null || dynamicVector == null) {
            sendSnackbarMessage("Activation required")
            return
        }
        val generateResponse = DigipassSDK.generateResponseOnly(staticVector, dynamicVector, "AX2E43", 0, DigipassSDKConstants.CRYPTO_APPLICATION_INDEX_APP_1, null)
        if (generateResponse.returnCode != DigipassSDKReturnCodes.SUCCESS) {
            sendSnackbarMessage("Can't generate OTP")
        } else {
            val otp = generateResponse.response
            otpLiveData.value = otp
        }
    }

    fun setActivation(result: String?) {
        if (result == null) {
            sendSnackbarMessage("Null result")
            return
        }
        val index = result.indexOf("FFFFFFFFFF")
        val staticStr = result.substring(0..(index - 1)).toUpperCase()
        val dynamicStr = result.substring((index + 10)..(result.length - 1)).toUpperCase()
        staticVector = staticStr.hexStringToByteArray()
        dynamicVector = dynamicStr.hexStringToByteArray()
    }

    private fun sendSnackbarMessage(message: String) {
        snackbarMessage.value = message
    }

    private val HEX_CHARS = "0123456789ABCDEF"

    private fun String.hexStringToByteArray(): ByteArray {

        val result = ByteArray(length / 2)

        for (i in 0 until length step 2) {
            val firstIndex = HEX_CHARS.indexOf(this[i])
            val secondIndex = HEX_CHARS.indexOf(this[i + 1])

            val octet = firstIndex.shl(4).or(secondIndex)
            result[i.shr(1)] = octet.toByte()
        }

        return result
    }
}