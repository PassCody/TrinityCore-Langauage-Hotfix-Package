# TrinityCore Language Hotfixes

This repository contains SQL hotfixes for language packages in TrinityCore. They fix encoding issues (broken special characters) in all `*_locale` tables for German, Spanish, and French.

---

## Files

1. **HOTFIX GERMAN LANGUAGE PACKAGE** – `HOTFIX_GERMAN_LANG_PACK.SQL`
   Fixes German special characters (`ä, ö, ü, Ä, Ö, Ü, ß`).

2. **HOTFIX SPANISH LANGUAGE PACKAGE** – `HOTFIX_ESPANIOL_LANG_PACK.SQL`
   Fixes Spanish special characters (`á, é, í, ó, ú, ñ, ü, ¡, ¿`).

3. **HOTFIX FRENCH LANGUAGE PACKAGE** – `HOTFIX_FRANCH_LANG_PACK.SQL`
   Fixes French special characters (`à, â, ç, é, è, ê, ë, î, ï, ô, ù, û, ü, œ, æ`).

4. **HOTFIX ALL LANGUAGES** – `HOTFIX_ALL_IN_ONE_LANG_PACK.SQL`
   Runs all three hotfixes in one go.

---

## Instructions

1. **Select your TrinityCore world database:**

   ```sql
   USE your_trinitycore_world_database;
   ```

2. **Run the SQL file:**

   * Using MySQL CLI:

     ```bash
     mysql -u <user> -p your_trinitycore_world_database < HOTFIX_GERMAN_LANG_PACK.SQL
     ```
   * Or via GUI tools (MySQL Workbench, HeidiSQL, phpMyAdmin):

     * Open the SQL file
     * Execute / Run

3. **Hotfix logic:**

   * Creates a temporary table listing all `_locale` columns
   * Uses a stored procedure to iterate all columns and replace broken characters
   * Cleans up procedure and temporary table after execution

4. **All languages in one step:**
   Execute `HOTFIX_ALL_IN_ONE_LANG_PACK.SQL` to apply German, Spanish, and French fixes simultaneously.

---

## Notes

* Hotfixes only affect entries with a valid `locale` column (`deDE`, `esES` and `esMX`, `frFR`).
* Backup your database before running. Changes are permanent.
* Running a hotfix multiple times is safe; no effect if characters are already correct.
* **Execution time:** The `HOTFIX_ALL_IN_ONE_LANG_PACK.SQL` script can take a few minutes (e.g., ~2–3 minutes) depending on database size. This is normal because all `_locale` tables and multiple columns per table are updated row by row. Performance can be improved by limiting tables/columns or batch processing, but the default procedure is safe and reliable.

---

## Quick Example

```bash
mysql -u root -p TrinityCoreDB < HOTFIX_ALL_IN_ONE_LANG_PACK.SQL
```

---

**Done.**
