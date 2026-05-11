# GymSystem Mobile App

Mobilna część systemu zarządzania siłownią realizowana w ramach projektu ZMP.
Aplikacja obsługuje klientów siłowni oraz konta trenerskie.

## Tech Stack

* **Framework**: Flutter 3.x
* **Język**: Dart 3.x
* **Stan aplikacji**: Riverpod
* **Komunikacja API**: Dio z interceptorem JWT
* **Powiadomienia**: WebSocket/STOMP oraz powiadomienia lokalne
* **Dane lokalne**: SharedPreferences dla ustawień oraz FlutterSecureStorage dla tokenu i cache offline danych użytkownika
* **Architektura**: feature-first

## Funkcjonalności

**Autoryzacja**
* Logowanie klasyczne.
* Rejestracja użytkownika z rolą klienta.
* Przechowywanie tokenu JWT w FlutterSecureStorage.

**Profil i klient**
* Podgląd profilu użytkownika.
* Sprawdzanie statusu karnetu.
* Przeglądanie grafiku zajęć.
* Zapisywanie się na zajęcia i anulowanie zapisu.
* Wybór lokalizacji klubu i sortowanie po odległości, jeśli użytkownik wyrazi zgodę na lokalizację.
* Wybór języka aplikacji.

**Karnety i dostęp**
* Zakup wybranego typu karnetu przez API.
* Kod QR jako wizualny element wejścia do klubu w projekcie studenckim.
* Blokada zrzutów ekranu podczas wyświetlania kodu QR.

**Tryb offline**
* Odczyt ostatnio pobranych danych profilu, karnetu, grafiku i uczestników zajęć po utracie połączenia.

**Moduł trenera**
* Widok zajęć prowadzonych przez trenera.
* Dodawanie, przekładanie i odwoływanie zajęć.
* Podgląd uczestników zajęć.

**Powiadomienia**
* Historia powiadomień z API.
* Powiadomienia w czasie rzeczywistym przez WebSocket.
* Oznaczanie powiadomień jako przeczytane i usuwanie ich.

## Konfiguracja

Domyślny backend jest ustawiony w `lib/core/config/env.dart`. Można go nadpisać podczas uruchamiania:

```bash
flutter run --dart-define=API_BASE_URL=https://example.com
```

## Weryfikacja

```bash
flutter analyze
flutter test
```
