# 📱 GymSystem Mobile App
Mobilna część systemu zarządzania siłownią realizowana w ramach projektu ZMP. Aplikacja została zaprojektowana z myślą o użytkownikach końcowych (klientach siłowni) oraz personelu trenerskim.

## 🛠 Tech Stack & Wersje
* **Framework**: Flutter 3.x

* **Język**: Dart 3.x

* **Zarządzanie stanem**: Riverpod (skalowalność i testowalność)

* **Komunikacja API**: Dio (z obsługą interceptorów dla JWT)

* **Baza danych lokalna**: Drift (SQLite) – obsługa trybu offline

* **Architektura**: Feature-first (podział na moduły funkcjonalne)

## 🚀 Funkcjonalności (Roadmap)
Na podstawie analizy wymagań, aplikacja realizuje następujące moduły:

**🔐 Autoryzacja i Bezpieczeństwo**
* Logowanie klasyczne oraz przez zewnętrzne serwisy (Facebook, Google).

* Rejestracja nowych użytkowników i system resetowania hasła.

* Dwuetapowa weryfikacja (2FA).

**👤 Profil i Klient**
* Zarządzanie profilem i sprawdzanie statusu karnetu.

* Przeglądanie listy zajęć w bieżącym tygodniu i zapisywanie się na nie.

* Lokalizator siłowni z informacją o aktualnym obłożeniu obiektu.

* Wybór języka aplikacji.

**🎫 System Dostępu i Offline**
* Kod QR: Generator kodów umożliwiający wejście do klubu.

* TRYB OFFLINE: Dostęp do kluczowych danych (karnet, grafik) bez połączenia z siecią.

**👟 Moduł Trenera**
* Dedykowane Konto dla Trenera.

* Zarządzanie listą zajęć prowadzonych przez trenera.

**🔔 Powiadomienia Systemowe**
* Aplikacja wysyła powiadomienia o:

* Zbliżającym się terminie wygaśnięcia karnetu.

* Odwołanych lub przełożonych zajęciach.

* Nadchodzących treningach, na które użytkownik jest zapisany.