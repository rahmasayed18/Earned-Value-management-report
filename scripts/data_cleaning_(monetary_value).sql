/*==============================================================================
    FILE: 03_numeric_cleaning.sql
        Prepare all cost-related fields for analysis by converting text-based
        currency fields into clean DECIMAL values.

    COVERS:
        - Removing currency symbols & commas
        - Creating clean numeric columns
        - Safe CAST to DECIMAL(10,2)
        - Cleaning:
              * project_budget_amount
              * total_phase_actual_spending_amount
              * final_estimate_of_actual_costs_through_end_of_phase_amount
        - Constructing final EVM cost fields (BAC, AC, EAC)
==============================================================================*/

--------------------------------------------------------------------------------
-- 4.1 CLEANING Monetary Columns (Removing $, commas, text artifacts)
--------------------------------------------------------------------------------

-- Backup original fields
ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN project_budget_amount_raw TEXT;

ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN total_phase_actual_spending_amount_raw TEXT;

ALTER TABLE counstruction_project.construction_budget 
ADD COLUMN final_estimate_actual_costs_raw TEXT;

UPDATE counstruction_project.construction_budget
SET project_budget_amount_raw = project_budget_amount,
    total_phase_actual_spending_amount_raw = total_phase_actual_spending_amount,
    final_estimate_actual_costs_raw = final_estimate_of_actual_costs_through_end_of_phase_amount;

--------------------------------------------------------------------------------
-- Remove $ and commas
--------------------------------------------------------------------------------

UPDATE counstruction_project.construction_budget
SET project_budget_amount_raw = REPLACE(REPLACE(project_budget_amount_raw, '$',''), ',', '');

UPDATE counstruction_project.construction_budget
SET total_phase_actual_spending_amount_raw = REPLACE(REPLACE(total_phase_actual_spending_amount_raw, '$',''), ',', '');

UPDATE counstruction_project.construction_budget
SET final_estimate_actual_costs_raw = REPLACE(REPLACE(final_estimate_actual_costs_raw, '$',''), ',', '');

--------------------------------------------------------------------------------
-- Create clean DECIMAL fields
--------------------------------------------------------------------------------

ALTER TABLE counstruction_project.construction_budget
ADD COLUMN project_budget_amount_clean DECIMAL(10,2);

ALTER TABLE counstruction_project.construction_budget
ADD COLUMN total_phase_actual_spending_amount_clean DECIMAL(10,2);

ALTER TABLE counstruction_project.construction_budget
ADD COLUMN final_estimate_actual_costs_clean DECIMAL(10,2);

--------------------------------------------------------------------------------
-- Convert to DECIMAL
--------------------------------------------------------------------------------

UPDATE counstruction_project.construction_budget
SET project_budget_amount_clean = CASE 
    WHEN project_budget_amount_raw REGEXP '^[0-9]+(\.[0-9]+)?$'
    THEN CAST(project_budget_amount_raw AS DECIMAL(10,2))
    ELSE NULL END;

UPDATE counstruction_project.construction_budget
SET total_phase_actual_spending_amount_clean = CASE 
    WHEN total_phase_actual_spending_amount_raw REGEXP '^[0-9]+(\.[0-9]+)?$'
    THEN CAST(total_phase_actual_spending_amount_raw AS DECIMAL(10,2))
    ELSE NULL END;

UPDATE counstruction_project.construction_budget
SET final_estimate_actual_costs_clean = CASE 
    WHEN final_estimate_actual_costs_raw REGEXP '^[0-9]+(\.[0-9]+)?$'
    THEN CAST(final_estimate_actual_costs_raw AS DECIMAL(10,2))
    ELSE NULL END;

--------------------------------------------------------------------------------
-- 4.2 Finalizing Cost-Related Analysis Fields
--------------------------------------------------------------------------------

-- Add status column for interpreting costs
ALTER TABLE counstruction_project.construction_budget
ADD COLUMN project_budget_amount_status VARCHAR(50);

UPDATE counstruction_project.construction_budget
SET project_budget_amount_status = 
    CASE 
        WHEN project_budget_amount_clean IS NOT NULL 
            AND total_phase_actual_spending_amount_clean IS NULL
            THEN 'Budget_Only'
        WHEN project_budget_amount_clean IS NOT NULL
            AND total_phase_actual_spending_amount_clean IS NOT NULL
            THEN 'Budget_and_Actuals'
        WHEN project_budget_amount_clean IS NULL
            AND total_phase_actual_spending_amount_clean IS NOT NULL
            THEN 'Actuals_Only'
        ELSE 'Unknown'
    END;

-- Add final unified budget column (BAC equivalent)
ALTER TABLE counstruction_project.construction_budget
ADD COLUMN final_project_budget_amount DECIMAL(10,2);

UPDATE counstruction_project.construction_budget
SET final_project_budget_amount =
    CASE 
        WHEN project_budget_amount_clean IS NOT NULL THEN project_budget_amount_clean
        WHEN total_phase_actual_spending_amount_clean IS NOT NULL THEN total_phase_actual_spending_amount_clean
        ELSE NULL
    END;

-- Add final unified "actual cost" field (AC equivalent)
ALTER TABLE counstruction_project.construction_budget
ADD COLUMN final_project_actual_cost DECIMAL(10,2);

UPDATE counstruction_project.construction_budget
SET final_project_actual_cost = total_phase_actual_spending_amount_clean;

-- Add final unified "estimate at completion" field (EAC)
ALTER TABLE counstruction_project.construction_budget
ADD COLUMN final_project_estimate_cost DECIMAL(10,2);

UPDATE counstruction_project.construction_budget
SET final_project_estimate_cost = final_estimate_actual_costs_clean;



