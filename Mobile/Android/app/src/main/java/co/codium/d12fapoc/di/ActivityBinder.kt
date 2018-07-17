package co.codium.d12fapoc.di


import co.codium.d12fapoc.feature.main.MainActivity
import co.codium.d12fapoc.feature.main.di.MainActivityModule
import dagger.Module
import dagger.android.ContributesAndroidInjector

@Module
abstract class ActivityBinder {

    @ContributesAndroidInjector(modules = [MainActivityModule::class])
    abstract fun bindMainActivity(): MainActivity

}