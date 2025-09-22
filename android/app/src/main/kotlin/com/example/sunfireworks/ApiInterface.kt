package com.crackersworld.android
import retrofit2.Call
import retrofit2.http.*


interface ApiInterface {
    @POST("driver/dcm-polyline/")
    fun sendDCMLocation(
        @Header("Authorization") bearerToken: String,
        @Query("location") location: String
    ): Call<submitresponse>

    @POST("driver/car-polyline/")
    fun sendCARLocation(
        @Header("Authorization") bearerToken: String,
        @Query("location") location: String
    ): Call<submitresponse>
}


