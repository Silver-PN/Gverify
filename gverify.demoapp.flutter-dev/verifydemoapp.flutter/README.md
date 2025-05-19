# vnpass

VNPass Project
GetIt - Getx - Dio - Retrofit - ObjectBox

## Build
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

## Install dependencies iOS
open ios/Runner.xcworkspace
pod install --verbose

## Generate Language:
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart

## Run Project
flutter run build_runner dev
dart run build_runner dev

## Build Android
. flutter build apk --release --flavor dev
. flutter build apk --release --flavor production
. flutter build appbundle --release --flavor pro

## Build iOS
flutter build ipa