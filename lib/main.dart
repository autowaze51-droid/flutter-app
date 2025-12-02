import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';

void main() {
  // Configurações iniciais obrigatórias
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Tela cheia (esconde barras)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // 2. Força orientação landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // 3. Mantém tela ligada
  SystemChrome.setPreferredOrientations([]);
  
  runApp(MyApp());
  
  // 4. Tenta se tornar launcher após 3 segundos
  Future.delayed(Duration(seconds: 3), () {
    _trySetAsLauncher();
  });
}

// Função para tentar tornar o app como launcher
_trySetAsLauncher() async {
  try {
    print("Tentando configurar como launcher...");
    
    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.HOME',
      package: 'com.seunome.shoppinglist',
      componentName: 'com.seunome.shoppinglist.MainActivity',
    );
    
    await intent.launch();
    print("Intent enviado com sucesso!");
    
  } catch (e) {
    print("Erro ao configurar launcher: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List TV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> shoppingItems = [];
  TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _setupAppLifecycle();
  }
  
  void _setupAppLifecycle() {
    // Monitora quando app perde foco
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      print('Estado do app: $msg');
      
      // Se app for minimizado ou perder foco
      if (msg == AppLifecycleState.paused.toString() || 
          msg == AppLifecycleState.inactive.toString()) {
        
        // Aguarda 500ms e tenta trazer de volta
        await Future.delayed(Duration(milliseconds: 500));
        _trySetAsLauncher();
      }
      
      return msg;
    });
  }
  
  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        shoppingItems.add(_controller.text);
        _controller.clear();
      });
    }
  }
  
  void _removeItem(int index) {
    setState(() {
      shoppingItems.removeAt(index);
    });
  }
  
  void _clearAll() {
    setState(() {
      shoppingItems.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SHOPPING LIST',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'TV Box Launcher',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white, size: 30),
                    onPressed: _trySetAsLauncher,
                    tooltip: 'Reativar Launcher',
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Input para adicionar itens
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Digite um item...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: (_) => _addItem(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.blue),
                      onPressed: _addItem,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Lista de itens
              Expanded(
                child: shoppingItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 80,
                              color: Colors.grey[700],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Lista vazia',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Adicione itens à sua lista',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: shoppingItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_box_outline_blank, 
                                     color: Colors.blue),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    shoppingItems[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              
              // Botões de ação
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _clearAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep),
                        SizedBox(width: 10),
                        Text('Limpar Tudo'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _trySetAsLauncher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.home),
                        SizedBox(width: 10),
                        Text('Forçar Launcher'),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Informação
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Este app inicia automaticamente quando a TV Box é ligada.\n'
                  'Pressione "Forçar Launcher" se voltar à tela inicial padrão.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
