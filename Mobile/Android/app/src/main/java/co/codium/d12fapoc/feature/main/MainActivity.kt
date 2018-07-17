package co.codium.d12fapoc.feature.main

import android.Manifest
import android.app.Activity
import android.arch.lifecycle.Observer
import android.arch.lifecycle.ViewModelProvider
import android.arch.lifecycle.ViewModelProviders
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.support.v7.app.AppCompatActivity
import android.view.View
import android.widget.Toast
import co.codium.d12fa_poc.R
import co.codium.d12fapoc.feature.fingerprint.FingerprintDialogFragment
import com.github.ajalt.reprint.core.Reprint
import com.vasco.digipass.sdk.utils.qrcodescanner.QRCodeScannerSDKActivity
import com.vasco.digipass.sdk.utils.qrcodescanner.QRCodeScannerSDKConstants
import com.vasco.digipass.sdk.utils.qrcodescanner.QRCodeScannerSDKErrorCodes
import com.vasco.digipass.sdk.utils.qrcodescanner.QRCodeScannerSDKException
import dagger.android.AndroidInjection
import io.github.krtkush.lineartimer.LinearTimer
import kotlinx.android.synthetic.main.activity_main.*
import pub.devrel.easypermissions.AfterPermissionGranted
import pub.devrel.easypermissions.EasyPermissions
import pub.devrel.easypermissions.PermissionRequest
import javax.inject.Inject

class MainActivity : AppCompatActivity(), FingerprintDialogFragment.OnFragmentInteractionListener {

    @Inject
    lateinit var mViewModelFactory: ViewModelProvider.Factory
    private lateinit var mViewModel: MainViewModel

    private lateinit var mLinearTimer: LinearTimer
    private var isStarted = false
    private val mHandler = Handler()

    companion object {
        private const val REQUEST_SCANNER = 1000
        private const val PERMISSIONS_REQUEST_CAMERA = 1001
    }

    private val mFingerprintDialogFragment by lazy {
        FingerprintDialogFragment.newInstance()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AndroidInjection.inject(this)
        setContentView(R.layout.activity_main)

        mViewModel = ViewModelProviders.of(this, mViewModelFactory).get(MainViewModel::class.java)

        initInstances()
        initObservers()
    }

    private fun initInstances() {
        supportActionBar?.title = "DataOne Asia"
        mLinearTimer = LinearTimer.Builder()
                .linearTimerView(linear_timer)
                .duration(30 * 1_000)
                .build()

        otp_btn.setOnClickListener {
            if (Reprint.isHardwarePresent()) {
                if (!mFingerprintDialogFragment.isAdded) {
                    mFingerprintDialogFragment.show(supportFragmentManager, FingerprintDialogFragment.TAG)
                }
            } else {
                mViewModel.genOTP()
            }
        }

        activate_btn.setOnClickListener {
            startScanner()
        }
    }

    private fun initObservers() {
        mViewModel.otpLiveData.observe(this, Observer {

            otp_tv.text = it

            if (!isStarted) {
                showOtpLayout()
                mLinearTimer.startTimer()
                isStarted = true
            } else {
                mLinearTimer.restartTimer()
            }

            mHandler.removeCallbacksAndMessages(null)
            mHandler.postDelayed(
                    {
                        mViewModel.genOTP()
                    },
                    30_000
            )
        })
        mViewModel.snackbarMessage.observe(this, Observer(this::showSnackbarMessage))
    }

    override fun onAuthenticated() {
        mViewModel.genOTP()
    }

    override fun onUnauthenticated() {
        showSnackbarMessage("ไม่พบลายนิ้วมือ")
    }

    private fun showSnackbarMessage(message: String?) {
        message ?: return
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }

    private fun hasCameraPermission(): Boolean {
        return EasyPermissions.hasPermissions(this, Manifest.permission.CAMERA)
    }

    private fun enableCamera() {
        EasyPermissions.requestPermissions(
                PermissionRequest
                        .Builder(this, PERMISSIONS_REQUEST_CAMERA, Manifest.permission.CAMERA)
                        .setRationale(getString(R.string.camera_permission_rationale))
                        .build()
        )
    }

    @AfterPermissionGranted(PERMISSIONS_REQUEST_CAMERA)
    private fun startScanner() {
        if (!hasCameraPermission()) {
            enableCamera()
            return
        }

        // Instantiate intent to start scanning activity
        val intent = Intent(this, QRCodeScannerSDKActivity::class.java)

        // We want a vibration feedback after scanning
        // Note that the vibration feedback is activated by default
        intent.putExtra(QRCodeScannerSDKConstants.EXTRA_VIBRATE, true)

        // indicate which sort of image we want to scan
        intent.putExtra(QRCodeScannerSDKConstants.EXTRA_CODE_TYPE,
                QRCodeScannerSDKConstants.QR_CODE + QRCodeScannerSDKConstants.CRONTO_CODE)

        // Enable the scanner overlay to facilitate scanning.
        intent.putExtra(QRCodeScannerSDKConstants.EXTRA_SCANNER_OVERLAY, true)

        // Launch QR Code Scanner activity
        startActivityForResult(intent, REQUEST_SCANNER)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        // Display the result
        when (resultCode) {
            Activity.RESULT_OK -> {

                // The result is returned as an extra
                val result = data!!.getStringExtra(QRCodeScannerSDKConstants.OUTPUT_RESULT)

                val codeType = data.getIntExtra(QRCodeScannerSDKConstants.OUTPUT_CODE_TYPE, 0)

                // Convert the result
                if (codeType == QRCodeScannerSDKConstants.CRONTO_CODE) {
                    // we have scan a cronto code => convert the hexa string to string

                    mViewModel.setActivation(result)

                    showSnackbarMessage("สำเร็จ")

                } else if (codeType == QRCodeScannerSDKConstants.QR_CODE) {
                    // we have scan a QR code => display directly the result
                }
            }

            Activity.RESULT_CANCELED -> {
                showSnackbarMessage("ยกเลิก")
            }

            QRCodeScannerSDKConstants.RESULT_ERROR -> {
                // Get returned exception
                val exception = data
                        ?.getSerializableExtra(QRCodeScannerSDKConstants.OUTPUT_EXCEPTION) as QRCodeScannerSDKException


                // Show error message
                when (exception.errorCode) {
                    QRCodeScannerSDKErrorCodes.CAMERA_NOT_AVAILABLE -> showSnackbarMessage("ไม่พบกล้อง")
                    QRCodeScannerSDKErrorCodes.PERMISSION_DENIED -> showSnackbarMessage("ไม่สามารถใช้งานกล้องได้")
                    QRCodeScannerSDKErrorCodes.NATIVE_LIBRARY_NOT_LOADED -> showSnackbarMessage("ระบบมีปัญหา")
                    QRCodeScannerSDKErrorCodes.INTERNAL_ERROR -> showSnackbarMessage("กรุณาลองอีกครั้ง")
                    else -> showSnackbarMessage("ไม่สำเร็จ")
                }
            }
        }
    }

    private fun showOtpLayout() {
        otp_btn.visibility = View.GONE
        otp_layout.visibility = View.VISIBLE
    }

}
