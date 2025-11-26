# 📱 App Lista de Compras - Flutter

Um aplicativo completo de lista de compras desenvolvido em Flutter com 4 páginas principais e dados locais.

## ✨ Características

- ✅ **4 Páginas Principais:**
  1. **Lista de Compras** - Visualize todos os produtos pendentes
  2. **Produtos Comprados** - Histórico de produtos já adquiridos
  3. **Categorias** - Organize produtos por categoria
  4. **Estatísticas** - Resumo de gastos e análises

- 📊 **Funcionalidades:**
  - Adicionar, editar e deletar produtos
  - Marcar produtos como comprados
  - Organizar produtos por categorias
  - Cálculo automático de totais
  - Dados persistidos localmente
  - Interface intuitiva com Material Design 3

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK instalado
- Android Studio ou VS Code com Flutter Extension
- Dispositivo físico ou emulador Android/iOS

### Passos

1. **Navegue até a pasta do projeto:**
```powershell
cd "C:\Users\Lenovo\Desktop\SDK Flutter\shopping_list_app"
```

2. **Instale as dependências (já feito):**
```powershell
flutter pub get
```

3. **Execute o aplicativo:**
```powershell
flutter run
```

## 📁 Estrutura do Projeto

```
shopping_list_app/
├── lib/
│   ├── main.dart                 # Arquivo principal
│   ├── models/
│   │   └── product.dart          # Modelo de produto
│   ├── providers/
│   │   └── shopping_list_provider.dart  # Gerenciador de dados
│   └── pages/
│       ├── home_page.dart        # Página principal
│       ├── purchased_page.dart    # Página de comprados
│       ├── categories_page.dart   # Página de categorias
│       └── history_page.dart      # Página de estatísticas
```

## 📖 Como Usar

### Home (Lista Principal)
- **Adicionar Produto**: Clique no botão `+` flutuante
- **Marcar Comprado**: Clique no checkbox ao lado do produto
- **Editar**: Clique nas 3 linhas e selecione "Editar"
- **Deletar**: Clique nas 3 linhas e selecione "Deletar"

### Categorias Disponíveis
- Alimentos
- Laticínios
- Padaria
- Frutas e Verduras
- Higiene

### Produtos Comprados
- Visualize produtos já comprados
- Limpe o histórico com o ícone de lixeira na AppBar

### Estatísticas
- Resumo geral (Total, Comprados, Pendentes)
- Valores (Total, Gasto, A Gastar)
- Detalhamento por categoria

## 🎨 Personalizações

Você pode personalizar:
- Cores da paleta no `main.dart`
- Categorias no `shopping_list_provider.dart`
- Produtos iniciais no `shopping_list_provider.dart`
- Ícones e temas em cada página

## 📝 Dados Locais

Os dados são armazenados em memória durante a execução. Para persistência permanente, você pode:
1. Integrar `sqflite` para banco de dados local
2. Usar `shared_preferences` para dados simples
3. Implementar `GetX` ou `Provider` para gerenciamento de estado

## 🐛 Troubleshooting

Se encontrar problemas:

1. **Limpe o projeto:**
```powershell
flutter clean
flutter pub get
```

2. **Recrie o build:**
```powershell
flutter run -v
```

3. **Verifique o diagnóstico:**
```powershell
flutter doctor
```

## 📱 Suporte

Para testar em diferentes dispositivos:

**Android:**
```powershell
flutter run
```

**iOS (macOS):**
```powershell
flutter run -d macos
```

**Web:**
```powershell
flutter run -d chrome
```

---

Desenvolvido com ❤️ em Flutter
