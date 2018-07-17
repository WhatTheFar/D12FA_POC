package co.codium.d12fapoc.feature.fingerprint

import android.content.Context
import android.content.DialogInterface
import android.os.Bundle
import android.support.v4.app.DialogFragment
import android.support.v4.app.FragmentManager
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import co.codium.d12fa_poc.R
import com.github.ajalt.reprint.core.AuthenticationResult
import com.github.ajalt.reprint.rxjava2.RxReprint
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import timber.log.Timber
import kotlin.math.acosh

class FingerprintDialogFragment : DialogFragment() {

    private var listener: OnFragmentInteractionListener? = null
    private val compositeDisposable = CompositeDisposable()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        dialog.window.requestFeature(Window.FEATURE_NO_TITLE)

        return inflater.inflate(R.layout.fragment_fingerprint, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        RxReprint
                .authenticate()
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        { result ->
                            when (result?.status) {
                                AuthenticationResult.Status.SUCCESS -> {
                                    Timber.wtf("SUCCESS")
                                    listener?.onAuthenticated()
                                }
                                AuthenticationResult.Status.NONFATAL_FAILURE -> {
                                    Timber.wtf("NONFATAL_FAILURE")
                                    Timber.wtf("${result.failureReason}  ${result.errorMessage}")
                                    listener?.onUnauthenticated()
                                }
                                AuthenticationResult.Status.FATAL_FAILURE -> {
                                    Timber.wtf("FATAL_FAILURE")
                                    Timber.wtf("${result.failureReason}  ${result.errorMessage}")
                                    listener?.onUnauthenticated()
                                }
                            }
                            dismiss()
                        },
                        {
                            Timber.wtf(it)
                            dismiss()
                        }
                )
                .let(compositeDisposable::add)
    }

    override fun show(manager: FragmentManager?, tag: String?) {
        super.show(manager, tag)
        Timber.wtf("show")
    }

    override fun onDismiss(dialog: DialogInterface?) {
        super.onDismiss(dialog)
        Timber.wtf("on dismiss")
        compositeDisposable.clear()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)

        listener = context as? OnFragmentInteractionListener
    }

    override fun onDetach() {
        super.onDetach()
        listener = null
    }

    interface OnFragmentInteractionListener {
        fun onAuthenticated()
        fun onUnauthenticated()
    }

    companion object {

        private const val ARG_TAG = "tag"

        const val TAG = "fingerprint_dialog_fragment"

        @JvmStatic
        fun newInstance() =
                FingerprintDialogFragment()
    }

}
