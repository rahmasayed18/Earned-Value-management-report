/*==============================================================================
    FILE: 04_cleaned_table.sql
        Build the final cleaned, analysis-ready table for reporting and
        Earned Value Management (EVM) analytics.

    INCLUDES:
        - Standardized dimension columns
        - Cleaned DATE fields
        - Cleaned DECIMAL cost fields
        - EVM-ready measures (BAC, AC, EAC placeholders)
        - Project metadata
==============================================================================*/

-- Drop table if exists (safe refresh)
DROP TABLE IF EXISTS construction_project.construction_budget_cleaned;
CREATE TABLE construction_project.construction_budget_cleaned AS
SELECT
    project_geographic_district,
    project_building_identifier,
    project_school_name,
    project_type,
    project_description,
    project_phase_name,
    project_status_name,
    project_phase_actual_start_date,
    project_phase_planned_end_date,
    project_phase_actual_end_date,
    project_budget_amount_clean AS project_budget_amount,
    total_phase_actual_spending_amount_clean AS total_phase_actual_spending_amount,
    final_estimate_actual_costs_clean AS final_estimate_of_actual_costs_through_end_of_phase_amount,
    -- Unified final amounts
    final_project_budget_amount AS bac,       -- Budget at Completion
    final_project_actual_cost AS ac,          -- Actual Cost
    final_project_estimate_cost AS eac,       -- Estimate at Completion
    project_budget_amount_status
FROM counstruction_project.construction_budget;
