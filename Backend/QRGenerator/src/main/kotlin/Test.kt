import com.vasco.digipass.sdk.DigipassSDK
import com.vasco.digipass.sdk.DigipassSDKReturnCodes
import com.vasco.digipass.sdk.responses.ActivationResponse
import java.math.BigInteger
import java.nio.charset.Charset
import java.util.*

fun main(args: Array<String>) {

    val staticVector = "3808011D01035644530210101010101010101023232323232323230301010401030501120601010701010801050901010A01010B01020C01010D01010E01010F0100100100112F120100130101140101150C4D7920524F2020202020202016010117044080E8051801002901082A01002B01002C01021135120100130101140102150C4D79204352202020202020201601011704408BE8D41801011901062101062901082A01002B01002C01021141120100130101140103150C4D79205349474E20202020201601011704408BE8D51801031901011A01001B01002101102201102301102901082A01002B01002C0102112F120101130100140104150C445020504C5553202020202016010117044080E8021801002901062A01002B01002C0102"; /* SV for demo DIGIPASS VDS0140000 with 1 APP RO, 1 APP CR, 1 APP SG */
    val serialNumber = "VDS0140000";
    val activationCode = "96A69026946FFFCE8E7B3EB16E6A537C";
    val erc = "1116C74";
    val activationPassword: String? = null;
    val dynamicVector: ByteArray? = null;
    val encryptionKey: ByteArray = byteArrayOf(
            0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x00, 0x01, 0x02, 0x03, 0x04,
            0x05, 0x06
    );


    val activateResponse: ActivationResponse = DigipassSDK.activateOfflineWithKey(staticVector, serialNumber, activationCode, erc, activationPassword, encryptionKey, dynamicVector)

    if (activateResponse.returnCode != DigipassSDKReturnCodes.SUCCESS) {
        println("Offline activation with encryption key FAILED - [ " + activateResponse.getReturnCode()
                + ": " + DigipassSDK.getMessageForReturnCode(activateResponse.getReturnCode()) + " ]\n")
    } else {
        println("Offline activation with encryption key SUCCEEDED\n");
    }

    println(activateResponse.dynamicVector.toString(Charset.defaultCharset()))
    println(activateResponse.staticVector.toString(Charset.defaultCharset()))

    println()

    println(Arrays.toString(activateResponse.dynamicVector))
    println(Arrays.toString(activateResponse.staticVector))

    println()

    println(activateResponse.dynamicVector)
    println(activateResponse.staticVector)

    println()

    println(activateResponse.dynamicVector.size)
    println(activateResponse.staticVector.size)

    val hexStr = String.format("%040x", BigInteger(1, activateResponse.staticVector))
    val hexStr2 = String.format("%040x", BigInteger(1, activateResponse.dynamicVector))
    println(hexStr)
    println(hexStr2)
    println(hexStr.length)
    println(hexStr2.length)


    val s = "12345FFFF67890"
    val i = s.indexOf("FFFF")
    println(s.substring(0..(i -1)))
    println(s.substring((i + 4)..(s.length -1)))
}