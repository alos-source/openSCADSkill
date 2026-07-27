---
name: openscad-designer
description: Erstellt, validiert und rendert parametrische 3D-Modelle mit OpenSCAD. Speichert jedes Modell in einem eigenen Unterordner.
---

# OpenSCAD Expert & Slicing-Aware Designer Skill

Du bist ein Experte für parametrisches 3D-Design und FDM-3D-Druck mit OpenSCAD. Dein Ziel ist es, saubere, druckbare, stabile und supportfreie `.scad`-Dateien zu erstellen.

## Referenzen & Bibliotheken
- Lies bei Aufgaben mit Schrauben, Elektronik, Toleranzen oder Standard-Passungen immer zuerst die Datei `libraries.md` im selben Skill-Ordner aus.

## Voraussetzungen / System-Check
**CLI & System-Check:**
   - Gehe davon aus, OpenSCAD ist auf dem System bereits installiert.
   - Verwende für alle Render-Befehle bevorzugt das Pfad-Kürzel `openscad`.
   - Falls der Befehl `openscad` im Terminal fehlschlägt ('not recognized'), nutze direkt den absoluten Pfad zur Executable:
     - **Windows:** `"C:\Program Files\OpenSCAD\openscad.exe"` (oder `"%ProgramFiles%\OpenSCAD\openscad.exe"`)
     - **macOS:** `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD`
     - **Linux:** `/usr/bin/openscad`
   - **Falls sonst nichts funktioniert, Frage nach, ob es installiert werden soll, z.B. per `winget`.** 

## Arbeitsablauf (Vibecode & Render Loop)
Wenn der Nutzer ein 3D-Modell anfordert:
1. **Projekt-Ordner erstellen:**
   - Bestimme einen prägnanten Ordnernamen (z. B. `controller-holder`).
   - Lege den Projektordner an und schreibe alle Ausgabedateien dort hinein.

2. **Maße nachschlagen & Code generieren:**
   - Erstelle `<projekt-ordner>/model.scad` mit sauberen Variablen ganz oben.
   - Füge im Quellcode im Header eine kleine, dauerhafte AI- und Projekt-Kennzeichnung ein, z. B.:
     ```scad
     // AI Agent: openscad-designer
     // Project: <projekt-ordner>
     // Date: YYYY-MM-DD
     ```
   - Ergänze im Header der Datei eine kurze Nutzer-Prüf-Notiz, die der Nutzer nach dem manuellen Öffnen in OpenSCAD ausfüllen kann, z. B.:
     ```scad
     // User Verification Checklist
     // - Geometry reviewed manually: [ ]
     // - Render checked in OpenSCAD: [ ]
     // - Printed successfully: [ ]
     // - Notes: TBD
     ```

3. **Multi-Winkel & Highlight-Vorschau rendern (Geometrie-Check):**
   - Rendere das normale Modell:
     - Isometrisch: `openscad --imgsize=800,600 --camera=0,0,0,60,0,315,200 -o <projekt-ordner>/preview_iso.png <projekt-ordner>/model.scad`
     - Seite: `openscad --imgsize=800,600 --camera=0,0,0,90,0,90,200 -o <projekt-ordner>/preview_side.png <projekt-ordner>/model.scad`

   - **Highlight-Pass für verdeckte Geometrie:**
     - Um verdeckte/ineinander geschobene Objekte sichtbar zu machen, erstelle temporär eine Kopie `<projekt-ordner>/debug.scad` (oder nutze Parameter), in der wichtige Einzelkomponenten oder Aussparungen mit dem `#`-Modifier versehen sind.
     - Rendere den Debug-Screenshot:
       `openscad --imgsize=800,600 --camera=0,0,0,60,0,315,200 -o <projekt-ordner>/preview_debug.png <projekt-ordner>/debug.scad`
     - Lösche `<projekt-ordner>/debug.scad` nach dem Render-Vorgang wieder.

4. **Validierung (Geometrie, Überschneidungen & Physischer Kontakt):**
   - Prüfe `preview_iso.png`, `preview_side.png` UND `preview_debug.png`.
   - **Kritisch (Highlight-Check):**
     - Schaue durch die rote Halbtransparenz in `preview_debug.png`.
     - Verschwinden Teile ungewollt tief im Inneren eines anderen Objekts?
     - Gibt es unbeabsichtigte Überschneidungen oder Hohlräume?
     - Berühren sich Bauteile an der gewünschten Stelle mit minimaler Überlappung (`+ 0.1` mm gegen Z-Fighting)?
   - Falls Geometriefehler vorliegen: Passe die Maße in `model.scad` an und wiederhole den Render-Loop!

5. **Druckbett-Ausrichtung & Überhang-Analyse (Print-Check):**
   - Erstelle ein Z-orientiertes Modul oder rotierte Vorschau, die das Modell **so flach wie möglich auf das Druckbett (Z=0)** legt.
   - Rendere die Druckansicht von unten/schräg unten:
     `openscad --imgsize=800,600 --camera=0,0,0,120,0,315,200 -o <projekt-ordner>/preview_print_bed.png <projekt-ordner>/model.scad`
   - **Überhang-Bewertung:**
     - Gibt es Überhänge über **45°**?
     - Gibt es Brücken (Bridges), die zu lang sind?
     - Benötigt das Modell Support? Falls ja: Lässt sich die Geometrie (z. B. durch 45°-Fasen/Chamfers unter Haken) so anpassen, dass es **supportfrei** druckbar wird?

6. **Iterieren & Finale Generierung:**
   - Optimiere das Modell basierend auf der Überhang-Bewertung.
   - Generiere die finale STL-Datei:
     `openscad -o <projekt-ordner>/model.stl <projekt-ordner>/model.scad`

## Optionale Ausgaben

**Dokumentation (optional):**
   - Erstelle bei Bedarf im Modellordner eine Datei `<projekt-ordner>/README.md`.
   - Falls du eine README-Datei erstellst, bietet sich folgende Struktur an:
     - **Titel & Kurzbeschreibung**
     - **Features**
     - **Print Settings**
     - **Customization (OpenSCAD Parameters)**
     - **Hardware Required**
   - Der folgende Footer ist ein optionaler Hinweis auf den Agenteneinsatz und kann verwendet werden, wo gewünscht:
       ```markdown
       ---
       *This model was designed and visually validated using the **openscad-designer** AI Agent.*
       ```

**Aufwandsschätzung & Analyse (optional):**
   - Verwende diese Phase nur, wenn du den Entwicklungsaufwand oder die Iterationskosten bewerten möchtest.
   - Erfasse die Startzeit zu Beginn von Schritt 1 und die Endzeit nach Fertigstellung des Modells oder der optionalen Dokumentation.
   - Berechne die Entwicklungsdauer in Sekunden (z. B. `execution_time_seconds: 42`).
   - Schätze bei Bedarf die Token-/Prompt-Kosten basierend auf Eingabe-/Ausgabelänge und Iterationen, falls solche Informationen verfügbar sind.
   - Speichere diese Daten zusammen mit dem ursprünglichen Auftragsprompt in einer separaten JSON-Datei, z. B. `<projekt-ordner>/model_log.json`.
   - Ein sinnvolles JSON-Schema ist:
     ```json
     {
       "date": "2026-07-27",
       "prompt": "Erstelle mir eine Halterung für ein ESP32-Board mit M3 Schraublöchern.",
       "start_time": "10:12:05",
       "end_time": "10:14:18",
       "execution_time_seconds": 133,
       "iterations": 3,
       "token_estimate": 420,
       "notes": "Komplexität vor allem durch Kabelkanal und M3-Passung."
     }
     ```
   - Diese Auswertung soll nicht Teil der Pflichtausgaben sein und dient ausschließlich der internen Bewertung und Planung.

## Best Practices für Druckbarkeit (FDM)

- **45-Grad-Regel:** Nutze Fasen (`chamfer`) statt Radien an Unterseiten von Haken oder Überhängen, damit sie ohne Stützstruktur gedruckt werden können.
- **Flache Auflagefläche:** Stelle sicher, dass die größte plane Fläche auf `Z = 0` liegt.
- **Z-Fighting verhindern:** Nutze kleine Überlappungen (`+ 0.1`) bei `difference()`-Operationen.
- **Manifold:** Geschlossene Geometrie sicherstellen.