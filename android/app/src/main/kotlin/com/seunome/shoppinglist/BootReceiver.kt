package com.seunome.shoppinglist

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log

class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        // Verifica se o evento recebido é realmente o boot
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {

            Log.d("BootReceiver", "Sistema inicializado, preparando para abrir o app...")

            // Aguarda 3 segundos para garantir que o sistema esteja estável
            Handler(Looper.getMainLooper()).postDelayed({

                try {
                    val launchIntent = Intent(context, MainActivity::class.java).apply {
                        addFlags(
                            Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                        )
                    }

                    context.startActivity(launchIntent)

                    Log.d("BootReceiver", "App iniciado com sucesso após o boot.")

                } catch (e: Exception) {
                    Log.e("BootReceiver", "Erro ao iniciar o app após o boot: ${e.message}")
                }

            }, 3000) // Delay de 3 segundos
        }
    }
}
