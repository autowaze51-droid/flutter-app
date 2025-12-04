package com.seunome.shoppinglist

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {

        val action = intent.action
        Log.d("BootReceiver", "BootReceiver acionado: $action")

        if (action == Intent.ACTION_BOOT_COMPLETED ||
            action == "android.intent.action.QUICKBOOT_POWERON"
        ) {

            try {
                // Aguardar o sistema estabilizar (evita crash em alguns dispositivos)
                Thread.sleep(5000)

                val launchIntent = Intent(context, MainActivity::class.java).apply {
                    addFlags(
                        Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
                    )
                }

                context.startActivity(launchIntent)
                Log.d("BootReceiver", "Aplicativo iniciado automaticamente após o boot")

            } catch (e: Exception) {
                Log.e("BootReceiver", "Erro ao iniciar app: ${e.message}")
            }
        }
    }
}
