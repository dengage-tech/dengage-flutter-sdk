package com.example.dengage_flutter_example.push

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.os.Build
import android.util.Log
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.dengage.sdk.Constants
import com.dengage.sdk.NotificationReceiver
import com.dengage.sdk.Utils
import com.dengage.sdk.models.Message
import com.example.dengage_flutter_example.R
import java.util.*


/**
 * Created by Batuhan Coskun on 19 December 2020
 */
class PushNotificationReceiver : NotificationReceiver() {

    override fun onCarouselRender(context: Context?, intent: Intent?, message: Message?) {
        super.onCarouselRender(context, intent, message)

        val items = message?.carouselContent
        if (items.isNullOrEmpty() || intent == null) return
        val size = items.size
        val current = 0
        val left = (current - 1 + size) % size
        val right = (current + 1) % size

        val itemTitle = items[current].title
        val itemDesc = items[current].description

        // set intets (right button, left button, item click)
        val itemIntent = getItemClickIntent(intent.extras, context?.packageName)
        val leftIntent = getLeftItemIntent(intent.extras, context?.packageName)
        val rightIntent = getRightItemIntent(intent.extras, context?.packageName)
        val deleteIntent = getDeleteIntent(intent.extras, context?.packageName)
        val contentIntent = getContentIntent(intent.extras, context?.packageName)
        val carouseItemIntent = PendingIntent.getBroadcast(
                context, 0,
                itemIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val carouselLeftIntent = PendingIntent.getBroadcast(
                context, 1,
                leftIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val carouselRightIntent = PendingIntent.getBroadcast(
                context, 2,
                rightIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val deletePendingIntent = PendingIntent.getBroadcast(
                context, 4,
                deleteIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val contentPendingIntent = PendingIntent.getBroadcast(
                context, 5,
                contentIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )

        // set views for the layout
        val collapsedView = RemoteViews(
                context?.packageName,
                R.layout.den_carousel_collapsed
        )
        collapsedView.setTextViewText(R.id.den_carousel_title, message.title)
        collapsedView.setTextViewText(R.id.den_carousel_message, message.message)
        val carouselView = RemoteViews(
                context?.packageName,
                R.layout.den_carousel_portrait
        )
        carouselView.setTextViewText(R.id.den_carousel_title, message.title)
        carouselView.setTextViewText(R.id.den_carousel_message, message.message)
        carouselView.setTextViewText(R.id.den_carousel_item_title, itemTitle)
        carouselView.setTextViewText(R.id.den_carousel_item_description, itemDesc)

        Utils.loadCarouselImageToView(
                carouselView,
                R.id.den_carousel_portrait_left_image,
                items[left]
        )
        Utils.loadCarouselImageToView(
                carouselView,
                R.id.den_carousel_portrait_current_image,
                items[current]
        )
        Utils.loadCarouselImageToView(
                carouselView,
                R.id.den_carousel_portrait_right_image,
                items[right]
        )

        carouselView.setOnClickPendingIntent(R.id.den_carousel_left_arrow, carouselLeftIntent)
        carouselView.setOnClickPendingIntent(
                R.id.den_carousel_portrait_current_image,
                carouseItemIntent
        )
        carouselView.setOnClickPendingIntent(R.id.den_carousel_item_title, carouseItemIntent)
        carouselView.setOnClickPendingIntent(R.id.den_carousel_item_description, carouseItemIntent)
        carouselView.setOnClickPendingIntent(R.id.den_carousel_right_arrow, carouselRightIntent)

        val channelId = createNotificationChannel(context, message)

        if (context != null) {
            // set views for the notification
            val notification = NotificationCompat.Builder(context, channelId)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setCustomContentView(collapsedView)
                    .setCustomBigContentView(carouselView)
                    .setContentIntent(contentPendingIntent)
                    .setDeleteIntent(deletePendingIntent)
                    .build()
            // show message
            val notificationManager = NotificationManagerCompat.from(context)
            notificationManager.notify(
                    message.messageSource,
                    message.messageId,
                    notification
            )
        }
    }

    override fun onCarouselReRender(context: Context?, intent: Intent?, message: Message?) {
        super.onCarouselReRender(context, intent, message)

        val items = message?.carouselContent
        if (items.isNullOrEmpty() || intent == null) return
        val bundle = intent.extras
        val prevIndex = bundle?.getInt("current")
        val navigation = bundle?.getString("navigation", "right")
        val size = items.size
        val current = if (navigation.equals("right")) {
            ((prevIndex ?: 0) + 1) % size
        } else {
            ((prevIndex ?: 0) - 1 + size) % size
        }
        val right = (current + 1) % size
        val left = (current - 1 + size) % size
        intent.putExtra("current", current)

        val itemTitle = items[current].title
        val itemDesc = items[current].description

        // set intents (next button, rigth button and item click)
        val itemIntent = getItemClickIntent(intent.extras, context?.packageName)
        val leftIntent = getLeftItemIntent(intent.extras, context?.packageName)
        val rightIntent = getRightItemIntent(intent.extras, context?.packageName)
        val deleteIntent = getDeleteIntent(intent.extras, context?.packageName)
        val contentIntent = getContentIntent(intent.extras, context?.packageName)
        val carouseItemIntent = PendingIntent.getBroadcast(
                context, 0,
                itemIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val carouselLeftIntent = PendingIntent.getBroadcast(
                context, 1,
                leftIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val carouselRightIntent = PendingIntent.getBroadcast(
                context, 2,
                rightIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val deletePendingIntent = PendingIntent.getBroadcast(
                context, 4,
                deleteIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )
        val contentPendingIntent = PendingIntent.getBroadcast(
                context, 5,
                contentIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )

        // set views for the layout
        val collapsedView = RemoteViews(
                context?.packageName,
                R.layout.den_carousel_collapsed
        )
        collapsedView.setTextViewText(R.id.den_carousel_title, message.title)
        collapsedView.setTextViewText(R.id.den_carousel_message, message.message)
        val carouselView = RemoteViews(
                context?.packageName,
                R.layout.den_carousel_portrait
        )
        carouselView.setTextViewText(R.id.den_carousel_title, message.title)
        carouselView.setTextViewText(R.id.den_carousel_message, message.message)
        carouselView.setTextViewText(R.id.den_carousel_item_title, itemTitle)
        carouselView.setTextViewText(R.id.den_carousel_item_description, itemDesc)

        Utils.loadCarouselImageToView(
                carouselView,
                R.id.den_carousel_portrait_left_image,
                items[left]
        )
        Utils.loadCarouselImageToView(
                carouselView,
                R.id.den_carousel_portrait_current_image,
                items[current]
        )
        Utils.loadCarouselImageToView(
                carouselView,
                R.id.den_carousel_portrait_right_image,
                items[right]
        )

        carouselView.setOnClickPendingIntent(R.id.den_carousel_left_arrow, carouselLeftIntent)
        carouselView.setOnClickPendingIntent(
                R.id.den_carousel_portrait_current_image,
                carouseItemIntent
        )
        carouselView.setOnClickPendingIntent(R.id.den_carousel_item_title, carouseItemIntent)
        carouselView.setOnClickPendingIntent(R.id.den_carousel_item_description, carouseItemIntent)
        carouselView.setOnClickPendingIntent(R.id.den_carousel_right_arrow, carouselRightIntent)

        val channelId = createNotificationChannel(context, message)

        if (context != null) {
            // set your views for the notification
            val notification = NotificationCompat.Builder(context, channelId)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setCustomContentView(collapsedView)
                    .setCustomBigContentView(carouselView)
                    .setContentIntent(contentPendingIntent)
                    .setDeleteIntent(deletePendingIntent)
                    .build()
            // show message again silently with next,prev and current item.
            notification.flags = Notification.FLAG_AUTO_CANCEL or Notification.FLAG_ONLY_ALERT_ONCE
            val notificationManager = NotificationManagerCompat.from(context);
            notificationManager.notify(
                    message.messageSource,
                    message.messageId,
                    notification
            )
        }
    }

    private fun createNotificationChannel(context: Context?, message: Message?): String {
        // generate new channel id for different sounds
        val soundUri = Utils.getSound(context, message?.sound)
        val channelId = UUID.randomUUID().toString()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager =
                    context!!.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            // delete old notification channels
            val channels = notificationManager.notificationChannels
            if (channels != null && channels.size > 0) {
                for (channel in channels) {
                    notificationManager.deleteNotificationChannel(channel.id)
                }
            }
            val notificationChannel = NotificationChannel(
                    channelId,
                    Constants.CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT
            )
            val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .build()
            notificationChannel.setSound(soundUri, audioAttributes)
            notificationManager.createNotificationChannel(notificationChannel)
        }
        return channelId
    }

    override fun onActionClick(context: Context?, intent: Intent) {
        val extras = intent.extras
        if (extras != null) {
            val actionId = extras.getString("id")
            val notificationId = extras.getInt("notificationId")
            val targetUrl = extras.getString("targetUrl")
            Log.d("DenPush", "$actionId is clicked")
        }

        // Remove if you prefer to handle targetUrl which is actually correspond a deeplink.
        super.onActionClick(context, intent)
    }
}