/*==============================================================================
    FILE: 01_column_standardization
        Standardize inconsistent column names in the construction_budget table.
        This improves schema consistency and ensures clean downstream processing.
==============================================================================*/

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `ï»¿Project Geographic District` TO project_geographic_district;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Building Identifier` TO project_building_identifier;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project School Name` TO project_school_name;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Type` TO project_type;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Description` TO project_description;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Phase Name` TO project_phase_name;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Status Name` TO project_status_name;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Phase Actual Start Date` TO project_phase_actual_start_date;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Phase Planned End Date` TO project_phase_planned_end_date;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Phase Actual End Date` TO project_phase_actual_end_date;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Project Budget Amount` TO project_budget_amount;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Final Estimate of Actual Costs Through End of Phase Amount`
 TO final_estimate_of_actual_costs_through_end_of_phase_amount;

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `Total Phase Actual Spending Amount` TO total_phase_actual_spending_amount; 

ALTER TABLE counstruction_project.construction_budget
RENAME COLUMN `DSF Number(s)` TO dfs_numbers;
