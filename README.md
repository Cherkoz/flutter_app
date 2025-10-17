# Flutter app

## Предварительные требования
Убедитесь, что у вас установлен [Flutter SDK](https://hrk-flutter-website.web.app/docs/get-started/install) и настроена среда разработки.

## Начало работы
Перейти в папку app:
```bash
cd app
```
Установить зависимости:
```bash
flutter pub get
```
Сгенерировать файлы для моделей (.g.dart файлы):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Запуск в режиме разработки
```bash
flutter run
```