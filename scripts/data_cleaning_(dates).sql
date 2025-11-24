/*==============================================================================
    FILE: 02_date_cleaning.sql
        Clean and standardize all date fields in the construction project dataset
        into a consistent YYYY-MM-DD DATE format.

    COVERS:
        3.1 Actual Start Date Cleaning Pipeline
        3.2 Planned End Date Cleaning Pipeline
        3.3 Actual End Date Cleaning Pipeline

    KEY ACTIONS:
        - Backup original raw text fields
        - Create clean DATE columns
        - Parse MM/DD/YYYY, YYYY-MM-DD, and mixed text formats
        - Preserve placeholder values (PNS, FTK, AU, WIP)
        - Drop intermediate helper columns after transformation
==============================================================================*/

--------------------------------------------------------------------------------
-- 3.1 CLEANING project_phase_actual_start_date
--------------------------------------------------------------------------------

-- Backup raw column
ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN project_phase_actual_start_date_raw TEXT;

UPDATE counstruction_project.construction_budget 
SET project_phase_actual_start_date_raw = project_phase_actual_start_date;

-- Create temporary DATE column
ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN project_phase_actual_start_date_clean DATE;

-- Parse MM/DD/YYYY
UPDATE counstruction_project.construction_budget
SET project_phase_actual_start_date_clean = STR_TO_DATE(project_phase_actual_start_date_raw, '%m/%d/%Y')
WHERE project_phase_actual_start_date_raw RLIKE '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- Parse ISO (YYYY-MM-DD)
UPDATE counstruction_project.construction_budget
SET project_phase_actual_start_date_clean = CAST(project_phase_actual_start_date_raw AS DATE)
WHERE project_phase_actual_start_date_clean IS NULL
  AND project_phase_actual_start_date_raw RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Preserve text status codes
UPDATE counstruction_project.construction_budget
SET project_phase_actual_start_date_clean = NULL
WHERE project_phase_actual_start_date_clean IS NULL
  AND project_phase_actual_start_date_raw IN ('PNS','FTK','AU','WIP');

-- Drop old column and rename
ALTER TABLE counstruction_project.construction_budget 
DROP COLUMN project_phase_actual_start_date;

ALTER TABLE counstruction_project.construction_budget 
CHANGE project_phase_actual_start_date_clean project_phase_actual_start_date DATE;

--------------------------------------------------------------------------------
-- 3.2 CLEANING project_phase_planned_end_date
--------------------------------------------------------------------------------

ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN project_phase_planned_end_date_raw TEXT;

UPDATE counstruction_project.construction_budget 
SET project_phase_planned_end_date_raw = project_phase_planned_end_date;

ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN project_phase_planned_end_date_clean DATE;

-- MM/DD/YYYY
UPDATE counstruction_project.construction_budget
SET project_phase_planned_end_date_clean = STR_TO_DATE(project_phase_planned_end_date_raw, '%m/%d/%Y')
WHERE project_phase_planned_end_date_raw RLIKE '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- ISO format
UPDATE counstruction_project.construction_budget
SET project_phase_planned_end_date_clean = CAST(project_phase_planned_end_date_raw AS DATE)
WHERE project_phase_planned_end_date_clean IS NULL
  AND project_phase_planned_end_date_raw RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Preserve codes
UPDATE counstruction_project.construction_budget
SET project_phase_planned_end_date_clean = NULL
WHERE project_phase_planned_end_date_clean IS NULL
  AND project_phase_planned_end_date_raw IN ('PNS','FTK','AU','WIP');

-- Drop old & rename
ALTER TABLE counstruction_project.construction_budget 
DROP COLUMN project_phase_planned_end_date;

ALTER TABLE counstruction_project.construction_budget 
CHANGE project_phase_planned_end_date_clean project_phase_planned_end_date DATE;

--------------------------------------------------------------------------------
-- 3.3 CLEANING project_phase_actual_end_date
--------------------------------------------------------------------------------

ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN project_phase_actual_end_date_raw TEXT;

UPDATE counstruction_project.construction_budget 
SET project_phase_actual_end_date_raw = project_phase_actual_end_date;

ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN project_phase_actual_end_date_clean DATE;

-- MM/DD/YYYY
UPDATE counstruction_project.construction_budget
SET project_phase_actual_end_date_clean = STR_TO_DATE(project_phase_actual_end_date_raw, '%m/%d/%Y')
WHERE project_phase_actual_end_date_raw RLIKE '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- ISO
UPDATE counstruction_project.construction_budget
SET project_phase_actual_end_date_clean = CAST(project_phase_actual_end_date_raw AS DATE)
WHERE project_phase_actual_end_date_clean IS NULL
  AND project_phase_actual_end_date_raw RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Preserve codes
UPDATE counstruction_project.construction_budget
SET project_phase_actual_end_date_clean = NULL
WHERE project_phase_actual_end_date_clean IS NULL
  AND project_phase_actual_end_date_raw IN ('PNS','FTK','AU','WIP');

-- Drop & rename
ALTER TABLE counstruction_project.construction_budget 
DROP COLUMN project_phase_actual_end_date;

ALTER TABLE counstruction_project.construction_budget 
CHANGE project_phase_actual_end_date_clean project_phase_actual_end_date DATE;
