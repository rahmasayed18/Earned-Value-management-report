# Earned Value Management Report

## Project Background
This dataset represents a full earned-value performance extract from a long-duration project, containing monthly records of Planned Value (PV), Actual Cost (AC), Earned Value (EV), and the calculated performance indicators used for cost and schedule analytics.  
It includes cumulative curves, performance indices (CPI, SPI), and cost/schedule variances, allowing a structured analysis of how the project progressed against both budget and timeline across its reporting window.

The analytical intent of the dataset is to evaluate financial efficiency, execution pace, and deviation from the baseline plan, using standard earned-value methodology.

---

## Data Structure & Initial Checks
The dataset includes the following core components:

- **Planned Value (PV):** Baseline cumulative cost expectations.  
- **Actual Cost (AC):** Real expenditures logged during each reporting month.  
- **Earned Value (EV):** The value of completed work mapped to the baseline.  
- **Performance Indicators (EVM KPIs):** CPI, SPI, CV, SV, and cumulative variance figures created through DAX.  
- **Monthly Time Index:** Ensures continuity for trend analysis and cumulative tracking.  

Initial checks included validation of date alignment between PV, AC, and EV; missing monthly postings; curve continuity; and consistency across cumulative calculations.

---

## Executive Summary
Across the full reporting period, the project displays stable cost control but slower-than-planned execution. The cost performance index remains above 1, confirming that expenditures are more efficient than the baseline expected. However, earned value growth does not keep pace with planned value, leading to schedule slippage of nearly ten percent by the end of the period. Despite this, major cost deviations remain contained, and actual spending trends remain consistently below or aligned with expectations. The overall position suggests a financially disciplined project that requires attention on delivery rate rather than spending rate.

<img width="1499" height="839" alt="Screenshot 2025-11-22 212423" src="https://github.com/user-attachments/assets/f7a15236-570c-49ba-893d-f35b40d5e07c" />


---

## Insights Deep Dive

### Cost Performance
- CPI trends stable above 1 for most of the timeline, showing the project consistently delivers more value per dollar spent than planned.
- Actual Cost almost always tracks under Earned Value, which reinforces that spending efficiency is holding even when work output slows.
- Cost variance remains positive; the project rarely experiences months where actual spending outpaces the value produced.
- By early 2025, cost behavior becomes even more predictable with reduced volatility, indicating maturing operational control.

### Schedule Performance
- SPI fluctuates around 1 but remains slightly below it by the final months, reflecting mild but persistent schedule slippage.
- The gap between PV and EV widens noticeably around mid-2023 and again in 2024 due to slower work completion rates.
- The cumulative delay stabilizes into a consistent lag rather than growing exponentially, meaning execution is slow but not deteriorating further.
- Several recovery attempts appear in early 2024 and mid-2025 but are not strong enough to close the full deviation.

### Variance Analysis
- Cost variance remains in positive territory, offering a financial buffer even as schedule performance weakens.
- Schedule variance mirrors the SPI trend, showing smaller month-to-month oscillations but settling in negative territory overall.
- Variance spikes appear during specific operational months where planned workloads were heavier, amplifying the schedule gap.
- Despite the delays, the cumulative EV trend bends upward steadily, indicating ongoing progress rather than stagnation.
