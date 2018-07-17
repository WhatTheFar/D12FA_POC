package co.codium.d12fapoc.di

import android.arch.lifecycle.ViewModel
import android.arch.lifecycle.ViewModelProvider
import co.codium.d12fapoc.feature.DaggerViewModelFactory
import co.codium.d12fapoc.feature.main.MainViewModel
import dagger.Binds
import dagger.Module
import dagger.multibindings.IntoMap

/**
 * Created by Far on 30/3/2018 AD.
 */
@Module
abstract class ViewModelModule {

    @Binds
    @IntoMap
    @ViewModelKey(MainViewModel::class)
    internal abstract fun bindMainViewModel(mainViewModel: MainViewModel): ViewModel

    @Binds
    internal abstract fun bindViewModelFactory(factory: DaggerViewModelFactory): ViewModelProvider.Factory
}