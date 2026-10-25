# Philips Hue Smart Button (Gen 2) Base / Wandadapter

3D-druckbare Basis und Wandadapter für den **Philips Hue Smart Button (Zweite Generation / v2)** mit 45 mm Durchmesser, passend für deutsche Lichtschalter-Programme.

## Merkmale & Spezifikationen
- **Passform Schalterprogramme:**
  - **System 55 (54.7 × 54.7 mm):** Passend für Standard-Rahmenausschnitte (55 mm) von Gira (System 55 / E2 / Standard 55), Jung (AS 500 / A 500), Merten (System M) und Berker (S.1 / B.3 / Q.1).
  - **Vollrahmen 80 × 80 mm:** Deckt deutsche Standard-Unterputzdosen (Ø68 mm) ab, mit standardisiertem 60 mm DIN 49073 Schraubenabstand und rückseitigem Hohlraum für WAGO-Klemmen.
- **Ferromagnetische Halterung (Magnet-Dock):**
  - Integrierte Tasche für handelsübliche ferromagnetische Metallscheiben (z. B. **DIN 9021 M8 Unterlegscheibe** mit Ø 24 mm oder 25 mm Stahlscheiben).
  - **Offene Front-Tasche (Standard in `model.stl`):** Direkt von vorne sichtbar, Scheibe kann nach dem Druck einfach eingedrückt oder eingeklebt werden.
  - **Interne versiegelte Tasche:** Unsichtbar im Druck versenkbar per *Pause-at-Height* bei $Z = 2.80\text{ mm}$ (Layer ~14) für eine 100% nahtlose Oberfläche.
- **Ergonomische Fingermulden:** Seitliche Aussparungen am Rand ermöglichen das einfache Herausnehmen des Buttons mit dem Fingernagel für den Batteriewechsel (CR2032).

Alle Dateien, Render-Vorschauen, OpenSCAD-Code und fertige STLs befinden sich im Unterordner [`gemini/`](./gemini/):
- [`gemini/model.scad`](./gemini/model.scad) – Parametrisches OpenSCAD-Modell
- [`gemini/model.stl`](./gemini/model.stl) – Standard-STL für System 55 (mit sichtbarer Front-Tasche)
- [`gemini/model_system55_front_pocket.stl`](./gemini/model_system55_front_pocket.stl) – System 55 mit offener Front-Tasche
- [`gemini/model_system55_internal_pocket.stl`](./gemini/model_system55_internal_pocket.stl) – System 55 mit interner Pause-at-Height Tasche
- [`gemini/model_full_frame_80x80_front_pocket.stl`](./gemini/model_full_frame_80x80_front_pocket.stl) – 80x80 mm Vollrahmen mit offener Front-Tasche
- [`gemini/model_full_frame_80x80_internal_pocket.stl`](./gemini/model_full_frame_80x80_internal_pocket.stl) – 80x80 mm Vollrahmen mit interner Tasche
- [`gemini/README.md`](./gemini/README.md) – Detaillierte Dokumentation & Druckanleitung
