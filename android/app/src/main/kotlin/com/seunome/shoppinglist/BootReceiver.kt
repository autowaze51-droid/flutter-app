package com.seunome.shoppinglist

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("BootReceiver", "Boot completo recebido: ${intent.action}")
        
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || 
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {
            
            try {
                // Aguarda 5 segundos para sistema estabilizar
                Thread.sleep(5000)
                
                // Inicia a MainActivity
                val launchIntent = Intent(context, MainActivity::class.java)
                launchIntent.addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                
                context.startActivity(launchIntent)
                Log.d("BootReceiver", "App iniciado com sucesso após boot")
                
            } catch (e: Exception) {
                Log.e("BootReceiver", "Erro ao iniciar app: ${e.message}")
            }
        }
    }
}
