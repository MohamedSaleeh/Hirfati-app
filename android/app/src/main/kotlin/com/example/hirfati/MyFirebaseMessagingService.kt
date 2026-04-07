package com.example.hirfati

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import android.util.Log

class MyFirebaseMessagingService : FirebaseMessagingService() {
    
    override fun onNewToken(token: String) {
        Log.d("FCM", "Refreshed token: $token")
       
    }
    
    override fun onMessageReceived(message: RemoteMessage) {
        Log.d("FCM", "Message received: ${message.notification?.title}")
        Log.d("FCM", "Message body: ${message.notification?.body}")
    }
}