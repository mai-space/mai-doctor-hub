-- schemaVersion 15
---
CREATE TABLE "app_settings" ("id" INTEGER NOT NULL DEFAULT 1, "morning_reminder_enabled" INTEGER NOT NULL DEFAULT 1 CHECK ("morning_reminder_enabled" IN (0, 1)), "evening_reminder_enabled" INTEGER NOT NULL DEFAULT 1 CHECK ("evening_reminder_enabled" IN (0, 1)), "morning_hour" INTEGER NOT NULL DEFAULT 8, "morning_minute" INTEGER NOT NULL DEFAULT 0, "evening_hour" INTEGER NOT NULL DEFAULT 20, "evening_minute" INTEGER NOT NULL DEFAULT 0, "calendar_sync_enabled" INTEGER NOT NULL DEFAULT 0 CHECK ("calendar_sync_enabled" IN (0, 1)), "calendar_id" TEXT NULL, "calendar_include_title" INTEGER NOT NULL DEFAULT 0 CHECK ("calendar_include_title" IN (0, 1)), "app_lock_enabled" INTEGER NOT NULL DEFAULT 0 CHECK ("app_lock_enabled" IN (0, 1)), "onboarding_completed" INTEGER NOT NULL DEFAULT 0 CHECK ("onboarding_completed" IN (0, 1)), "appointment_reminders_enabled" INTEGER NOT NULL DEFAULT 1 CHECK ("appointment_reminders_enabled" IN (0, 1)), "appointment_reminder_leads" TEXT NOT NULL DEFAULT '1440,60', "notification_topics" TEXT NOT NULL DEFAULT '', "cycle_tracking" INTEGER NOT NULL DEFAULT 0 CHECK ("cycle_tracking" IN (0, 1)), "menopause_tracking" INTEGER NOT NULL DEFAULT 0 CHECK ("menopause_tracking" IN (0, 1)), "pregnancy_tracking" INTEGER NOT NULL DEFAULT 0 CHECK ("pregnancy_tracking" IN (0, 1)), "show_fertile_window" INTEGER NOT NULL DEFAULT 0 CHECK ("show_fertile_window" IN (0, 1)), "temperature_unit" TEXT NULL, "glucose_unit" TEXT NULL, "weight_unit" TEXT NULL, "psych_questionnaires" INTEGER NOT NULL DEFAULT 0 CHECK ("psych_questionnaires" IN (0, 1)), PRIMARY KEY ("id"));
---
CREATE TABLE "appointment_diagnoses" ("appointment_id" TEXT NOT NULL REFERENCES appointments (id), "diagnosis_id" TEXT NOT NULL REFERENCES diagnoses (id), PRIMARY KEY ("appointment_id", "diagnosis_id"));
---
CREATE TABLE "appointment_symptoms" ("appointment_id" TEXT NOT NULL REFERENCES appointments (id), "symptom_id" TEXT NOT NULL REFERENCES symptoms (id), PRIMARY KEY ("appointment_id", "symptom_id"));
---
CREATE TABLE "appointments" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "doctor_id" TEXT NOT NULL REFERENCES doctors (id), "scheduled_at" INTEGER NOT NULL, "duration_min" INTEGER NULL, "title" TEXT NULL, "notes" TEXT NULL, "status" INTEGER NOT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "calendar_links" ("appointment_id" TEXT NOT NULL, "calendar_id" TEXT NOT NULL, "external_event_id" TEXT NULL, "payload_hash" TEXT NULL, "synced_at" INTEGER NULL, "last_error" TEXT NULL, PRIMARY KEY ("appointment_id"));
---
CREATE TABLE "cycle_days" ("day" TEXT NOT NULL, "flow" INTEGER NULL, "pbac_json" TEXT NULL, "pain" INTEGER NULL, "pain_locations" TEXT NULL, "symptoms" TEXT NULL, "discharge" TEXT NULL, "painkiller" INTEGER NULL CHECK ("painkiller" IN (0, 1)), "painkiller_name" TEXT NULL, "painkiller_helped" INTEGER NULL CHECK ("painkiller_helped" IN (0, 1)), "hot_flashes" INTEGER NULL, "hot_flash_intensity" INTEGER NULL, "night_sweats" INTEGER NULL, "fetal_movement" INTEGER NULL, "weight_kg" REAL NULL, "bp_systolic" INTEGER NULL, "bp_diastolic" INTEGER NULL, "note" TEXT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("day"));
---
CREATE TABLE "diagnoses" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "title" TEXT NOT NULL, "notes" TEXT NULL, "started_at" INTEGER NULL, "ended_at" INTEGER NULL, "status" INTEGER NOT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "doctor_symptoms" ("doctor_id" TEXT NOT NULL REFERENCES doctors (id), "symptom_id" TEXT NOT NULL REFERENCES symptoms (id), PRIMARY KEY ("doctor_id", "symptom_id"));
---
CREATE TABLE "doctors" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "name" TEXT NOT NULL, "specialty" TEXT NULL, "practice_name" TEXT NULL, "phone" TEXT NULL, "address" TEXT NULL, "notes" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "medication_intakes" ("id" TEXT NOT NULL, "medication_id" TEXT NOT NULL REFERENCES medications (id), "scheduled_for" INTEGER NULL, "recorded_at" INTEGER NOT NULL, "status" INTEGER NOT NULL, "dose_amount" REAL NULL, "note" TEXT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "medication_schedules" ("id" TEXT NOT NULL, "medication_id" TEXT NOT NULL REFERENCES medications (id), "slot" INTEGER NOT NULL UNIQUE, "hour" INTEGER NOT NULL, "minute" INTEGER NOT NULL, "weekdays" INTEGER NOT NULL DEFAULT 127, "dose_amount" REAL NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "medications" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "name" TEXT NOT NULL, "dosage" TEXT NULL, "schedule_text" TEXT NULL, "diagnosis_id" TEXT NULL REFERENCES diagnoses (id), "started_at" INTEGER NULL, "ended_at" INTEGER NULL, "notes" TEXT NULL, "created_at" INTEGER NOT NULL, "form" INTEGER NULL, "dose_amount" REAL NULL, "dose_unit" TEXT NULL, "instructions" TEXT NULL, "prescriber_id" TEXT NULL REFERENCES doctors (id), "pharmacy_id" TEXT NULL REFERENCES pharmacies (id), "reminders_enabled" INTEGER NOT NULL DEFAULT 1 CHECK ("reminders_enabled" IN (0, 1)), PRIMARY KEY ("id"));
---
CREATE TABLE "mrs_assessments" ("id" TEXT NOT NULL, "recorded_at" INTEGER NOT NULL, "scores" TEXT NOT NULL, "note" TEXT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "notes" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "body" TEXT NOT NULL, "related_appointment_id" TEXT NULL REFERENCES appointments (id), "related_diagnosis_id" TEXT NULL REFERENCES diagnoses (id), "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "pharmacies" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "name" TEXT NOT NULL, "address" TEXT NULL, "phone" TEXT NULL, "notes" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "pregnancies" ("id" TEXT NOT NULL, "lmp" TEXT NULL, "due_date" TEXT NULL, "created_at" INTEGER NOT NULL, "ended_at" INTEGER NULL, "outcome" TEXT NULL, "note" TEXT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "psych_assessments" ("id" TEXT NOT NULL, "recorded_at" INTEGER NOT NULL, "instrument" TEXT NOT NULL, "scores" TEXT NOT NULL, "note" TEXT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE record_vectors (
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      chunk INTEGER NOT NULL,
      model TEXT NOT NULL,
      source_hash TEXT NOT NULL,
      content TEXT NOT NULL,
      vector BLOB NOT NULL,
      PRIMARY KEY (entity_type, entity_id, chunk)
    );
---
CREATE VIRTUAL TABLE records_fts USING fts5(
          entity_type,
          entity_id,
          title,
          body,
          tokenize = 'unicode61'
        );
---
CREATE TABLE "reminder_symptoms" ("reminder_id" TEXT NOT NULL REFERENCES reminders (id), "symptom_id" TEXT NOT NULL REFERENCES symptoms (id), PRIMARY KEY ("reminder_id", "symptom_id"));
---
CREATE TABLE "reminders" ("id" TEXT NOT NULL, "slot" INTEGER NOT NULL UNIQUE, "title" TEXT NOT NULL, "body" TEXT NULL, "hour" INTEGER NOT NULL, "minute" INTEGER NOT NULL, "weekdays" INTEGER NOT NULL DEFAULT 127, "enabled" INTEGER NOT NULL DEFAULT 1 CHECK ("enabled" IN (0, 1)), "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "reports" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "appointment_id" TEXT NULL REFERENCES appointments (id), "title" TEXT NOT NULL, "mime_type" TEXT NOT NULL, "local_path" TEXT NOT NULL, "extracted_text" TEXT NULL, "page_count" INTEGER NULL, "source" INTEGER NOT NULL, "created_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "symptom_media" ("id" TEXT NOT NULL, "symptom_id" TEXT NOT NULL REFERENCES symptoms (id), "observation_id" TEXT NULL REFERENCES symptom_observations (id), "kind" INTEGER NOT NULL, "mime_type" TEXT NOT NULL, "local_path" TEXT NOT NULL, "duration_ms" INTEGER NULL, "note" TEXT NULL, "recorded_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "symptom_observations" ("id" TEXT NOT NULL, "symptom_id" TEXT NOT NULL REFERENCES symptoms (id), "recorded_at" INTEGER NOT NULL, "kind" INTEGER NOT NULL, "value_number" REAL NULL, "value_text" TEXT NULL, "value_color" TEXT NULL, "unit" TEXT NULL, "note" TEXT NULL, "sensation" TEXT NULL, "quality" TEXT NULL, "location" TEXT NULL, "side" TEXT NULL, "pattern" TEXT NULL, "measure" TEXT NULL, "value_number2" REAL NULL, "measure2" TEXT NULL, "secondary_value" REAL NULL, "energy" INTEGER NULL, "sleep_hours" REAL NULL, "anxiety" INTEGER NULL, "journal" TEXT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "symptoms" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "label" TEXT NOT NULL, "diagnosis_id" TEXT NULL REFERENCES diagnoses (id), "body_region" TEXT NULL, "healed_at" INTEGER NULL, "check_in_cadence" INTEGER NOT NULL, "reminder_times_json" TEXT NOT NULL DEFAULT '[]', "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, "sensation" TEXT NULL, "quality" TEXT NULL, "side" TEXT NULL, "measure" TEXT NULL, "measure2" TEXT NULL, PRIMARY KEY ("id"));
---
CREATE TABLE "vaccinations" ("archived_at" INTEGER NULL, "id" TEXT NOT NULL, "vaccine" TEXT NOT NULL, "product" TEXT NULL, "administered_at" INTEGER NOT NULL, "dose_number" INTEGER NULL, "batch" TEXT NULL, "doctor_id" TEXT NULL REFERENCES doctors (id), "next_due_at" INTEGER NULL, "notes" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
