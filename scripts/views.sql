/*==============================================================================
    FILE: view_construction_budget_analysis.sql
        Create a consolidated view for Earned Value Management (EVM) metrics
        based on the cleaned construction_budget table.
        
    INCLUDES:
        - PV, EV, AC, CV, SV
        - CPI, SPI
        - ETC, VAC
==============================================================================*/

DROP VIEW IF EXISTS counstruction_project.construction_budget_analysis;

CREATE VIEW counstruction_project.construction_budget_analysis AS

WITH budget_analysis AS (
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
        perc_complete,
        CASE
            WHEN project_phase_actual_start_date IS NULL
                 OR project_phase_planned_end_date IS NULL
                 OR STR_TO_DATE(project_phase_actual_start_date, '%Y-%m-%d') IS NULL
                 OR STR_TO_DATE(project_phase_planned_end_date, '%Y-%m-%d') IS NULL
            THEN 
              LEAST(COALESCE(AC, 0.0) / NULLIF(EAC, 0.0), 1.0)
            ELSE 
              LEAST(
                  GREATEST(
                      DATEDIFF(
                        LEAST(CURRENT_DATE, STR_TO_DATE(project_phase_planned_end_date, '%Y-%m-%d')),
                        STR_TO_DATE(project_phase_actual_start_date, '%Y-%m-%d')
                      ) / NULLIF(
                        DATEDIFF(
                          STR_TO_DATE(project_phase_planned_end_date, '%Y-%m-%d'),
                          STR_TO_DATE(project_phase_actual_start_date, '%Y-%m-%d')
                        ),
                      0),
                  0.0),
              1.0)
        END AS pv_progress,
        BAC,
        EAC,
        AC,
        perc_complete * BAC / 100 AS EV,
        ROUND((perc_complete * BAC / 100) - AC , 2) AS CV,
        CASE
            WHEN EAC IS NULL THEN NULL
            ELSE ROUND(
                EAC *
                CASE
                    WHEN project_phase_actual_start_date IS NULL
                         OR project_phase_planned_end_date IS NULL
                         OR STR_TO_DATE(project_phase_actual_start_date, '%Y-%m-%d') IS NULL
                         OR STR_TO_DATE(project_phase_planned_end_date, '%Y-%m-%d') IS NULL
                    THEN LEAST(COALESCE(AC, 0.0) / NULLIF(EAC, 0.0), 1.0)
                    ELSE LEAST(
                        GREATEST(
                            DATEDIFF(
                              LEAST(CURRENT_DATE, STR_TO_DATE(project_phase_planned_end_date, '%Y-%m-%d')),
                              STR_TO_DATE(project_phase_actual_start_date, '%Y-%m-%d')
                            ) / NULLIF(
                              DATEDIFF(
                                STR_TO_DATE(project_phase_planned_end_date, '%Y-%m-%d'),
                                STR_TO_DATE(project_phase_actual_start_date, '%Y-%m-%d')
                              ), 0),
                        0.0),
                    1.0)
                END, 2)
        END AS pv
    FROM counstruction_project.construction_budget_cleaned
    WHERE project_building_identifier IN (
        SELECT project_building_identifier
        FROM counstruction_project.construction_budget_cleaned
        GROUP BY project_building_identifier
        HAVING SUM(CASE WHEN LOWER(project_status_name) = 'complete' THEN 1 ELSE 0 END)
               < COUNT(*)
    )
)

SELECT
    *,
    ROUND(EV - PV, 2) AS SV,
    ROUND(EV / AC , 2) AS CPI,
    ROUND(EV / PV) AS SPI,
    EAC - AC AS ETC,
    BAC - EAC AS VAC
FROM budget_analysis;
