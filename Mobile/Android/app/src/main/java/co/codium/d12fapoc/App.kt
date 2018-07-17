package co.codium.d12fapoc

import android.app.Activity
import android.app.Application
import co.codium.d12fa_poc.BuildConfig
import co.codium.d12fapoc.di.DaggerAppComponent
import com.github.ajalt.reprint.core.Reprint
import dagger.android.AndroidInjector
import dagger.android.DispatchingAndroidInjector
import dagger.android.HasActivityInjector
import timber.log.Timber
import javax.inject.Inject

class App : Application(), HasActivityInjector {

    @Inject
    lateinit var activityInjector: DispatchingAndroidInjector<Activity>

    override fun onCreate() {
        super.onCreate()

        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        }

        DaggerAppComponent
                .builder()
                .application(this)
                .build()
                .inject(this)

        Reprint.initialize(this)
    }

    override fun activityInjector(): AndroidInjector<Activity> = activityInjector

}
